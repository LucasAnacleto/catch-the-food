extends Node2D


# measurements
onready var map_width := int(get_viewport().size.x * 20)
onready var screen_width := get_viewport().size.x as int
onready var middle_of_screen := screen_width / 2.0
onready var middle_of_last_screen := map_width - middle_of_screen
# objects
onready var map_generator := $PlatformGenerator as PlatformMapGenerator
onready var player := $Player as KinematicBody2D
onready var player_camera := $Player/Camera as Camera2D
onready var camera := $Camera as Camera2D
onready var bgm := $Audio/Music
# positions
onready var player_start_position := player.position

var next_player : KinematicBody2D


func _ready():
	_change_player()
	map_generator.generate_map(map_width)

func _process(delta):
	var player_exact_position = int(ceil(player.position.x))

	if player.is_dead:
		_end_game()

	if player.position.x > 0 and not player.is_dead:
		PlayerStats.score = int(player.position.x / 50.0)

	if player_exact_position >= middle_of_screen and player_exact_position < middle_of_last_screen:
		_end_map_transition()

	if player_exact_position >= middle_of_last_screen and player_exact_position < map_width:
		_start_map_transition()

	if player_exact_position > map_width:
		_reset_map()


func _start_map_transition() -> void:
	bgm.volume_db -= 0.2
	player.can_jump = false
	player_camera.clear_current()


func _end_map_transition() -> void:
	player.can_jump = true
	player_camera.make_current()


func _reset_map() -> void:
	PlayerStats.level_up()
	bgm.volume_db = 0
	bgm.play()
	map_generator.clear_map()
	map_generator.generate_map(map_width)
	camera.make_current()
	player.position = player_start_position


func _end_game() -> void:
	bgm.stop()
	yield(get_tree().create_timer(1.5), "timeout")
	PlayerStats.reset_score()
	PlayerStats.reset_health()
	get_tree().reload_current_scene()


func _change_player():
	var player_parent = player.get_parent()

	next_player.can_jump = player.can_jump
	next_player.can_move = player.can_move
	next_player.automove_to = player.automove_to
	next_player.max_jump_height = player.max_jump_height
	next_player.velocity = player.velocity
	next_player.gravity = player.gravity
	next_player.position = player.position

	player.remove_child(player_camera)
	next_player.add_child(player_camera)
	player_parent.remove_child(player)
	player_parent.add_child(next_player)

	player = next_player


func _on_Platforms_theme_changed(theme):
	next_player = theme.cat.instance()
