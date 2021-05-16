extends CanvasLayer


const SCORE_TEXT = "%sm"

onready var menu := $GameMenu as PanelContainer
onready var score := $Score as Label


func _ready():
	PlayerStats.connect("score_changed", self, "_set_score_text")

	if PlayerStats.first_run:
		_pause_game()

func _process(delta):
	if Input.is_action_just_pressed("game_pause"):
		_pause_game()


func _set_score_text(value):
	score.text = SCORE_TEXT % value


func _pause_game():
	get_tree().paused = !get_tree().paused

	if get_tree().paused:
		menu.visible = true
	else:
		menu.visible = false
