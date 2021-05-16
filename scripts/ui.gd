extends CanvasLayer


const SCORE_TEXT = "%sm"

onready var menu := $GameMenu as Panel
onready var score := $Score as Label


func _ready():
	PlayerStats.connect("score_changed", self, "_set_score_text")


func _process(delta):
	if Input.is_action_just_pressed("game_pause"):
		get_tree().paused = !get_tree().paused

		if get_tree().paused:
			menu.visible = true
		else:
			menu.visible = false


func _set_score_text(value):
	score.text = SCORE_TEXT % value
