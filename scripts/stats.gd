extends Node


signal no_health
signal health_chaged(value)
signal max_health_chaged(value)


export(int) var max_health = 1 setget set_max_health

var health = max_health setget set_health
var score := 0 setget set_score
var total := 0
var first_run := true


func _ready():
	self.health = max_health


func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_chaged", max_health)


func set_health(value):
	health = value
	emit_signal("health_chaged", health)


func reset_health():
	self.health = max_health


func set_score(points: int) -> void:
	if first_run:
		first_run = false

	score = points + total


func level_up() -> void:
	total = score


func reset_score() -> void:
	score = 0
	total = 0
