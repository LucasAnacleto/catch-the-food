extends KinematicBody2D


signal collided(collision)

enum AutomoveDirection {TOP, RIGHT, BOTTOM, LEFT, NONE}
enum Direction {RIGHT, LEFT, NONE}

const UP = Vector2(0, -1)

export var can_jump := true
export var max_jump_height := 150
export var can_move := false
export(AutomoveDirection) var automove_to := AutomoveDirection.NONE
export var velocity := 300
export var gravity := 10

var motion := Vector2()
var is_dead := false

onready var sprite := $AnimatedSprite as AnimatedSprite


func _physics_process(_delta):
	var should_move_to = get_move_direction()

	if is_dead:
		sprite.play('dead')
		return

	match should_move_to:
		Direction.RIGHT:
			motion.x = velocity
			sprite.flip_h = false
			sprite.play('run')
		Direction.LEFT:
			motion.x = -velocity
			sprite.flip_h = true
			sprite.play('run')
		_:
			motion.x = 0
			sprite.play('idle')

	if should_jump():
		if is_on_floor():
			motion.y = -max_jump_height

	motion.y += gravity

	motion = move_and_slide(motion, UP)

	for i in get_slide_count():
		emit_signal("collided", get_slide_collision(i))


func get_move_direction() -> int:
	if (can_move && _is_action_pressed("right")) or automove_to == AutomoveDirection.RIGHT:
		return Direction.RIGHT

	if (can_move && _is_action_pressed("left")) or automove_to == AutomoveDirection.LEFT:
		return Direction.LEFT

	return Direction.NONE


func should_jump() -> bool:
	return can_jump && Input.is_action_just_pressed("player_jump")


func die() -> void:
	is_dead = true


func _is_action_pressed(direction: String) -> bool:
	return Input.is_action_pressed("player_" + direction)
