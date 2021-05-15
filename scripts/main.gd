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
# positions
onready var player_start_position := player.position


func _ready():
	map_generator.generate_map(map_width)

func _process(delta):
	var player_exact_position = int(ceil(player.position.x))

	if player_exact_position >= middle_of_screen and player_exact_position < middle_of_last_screen:
		_end_map_transition()

	if player_exact_position >= middle_of_last_screen and player_exact_position < map_width:
		_start_map_transition()

	if player_exact_position > map_width:
		_reset_map()


func _start_map_transition() -> void:
#	bgm.volume_db -= 0.2
	player.input_enabled = false
	player.can_jump = false
	player_camera.clear_current()


func _end_map_transition() -> void:
	player.input_enabled = true
	player.can_jump = true
	player_camera.make_current()


func _reset_map() -> void:
#	State.level_up()
#	bgm.volume_db = 0
#	bgm.play()
	map_generator.clear_map()
	map_generator.generate_map(map_width)
	camera.make_current()
	player.position = player_start_position
