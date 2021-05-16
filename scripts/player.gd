extends KinematicBody2D


enum AutomoveDirection {TOP, RIGHT, BOTTOM, LEFT, NONE}
enum Direction {RIGHT, LEFT, NONE}

const UP = Vector2(0, -1)
const SPEED_STEP = 4
const KILLER_TILES = ["grid", "water"]

export var can_jump := true
export var max_jump_height := 150
export var can_move := false
export(AutomoveDirection) var automove_to := AutomoveDirection.NONE
export var velocity := 300
export var gravity := 10

var motion := Vector2()
var is_dead := false

onready var sprite := $AnimatedSprite as AnimatedSprite
onready var area := $Area2D as Area2D


func _ready():
	area.connect("area_shape_entered", self, "_on_Area2D_area_shape_entered")


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
		var collision := get_slide_collision(i)

		if collision.collider.get_class() == "TileMap":
			var collision_position_in_grid = collision.collider.world_to_map(collision.position - Vector2(2, 0))
			var collided_cell = collision.collider.get_cellv(collision_position_in_grid)

			if KILLER_TILES.has(collision.collider.tile_set.tile_get_name(collided_cell)):
				die()


func get_move_direction() -> int:
	if (can_move && _is_action_pressed("right")) or automove_to == AutomoveDirection.RIGHT:
		return Direction.RIGHT

	if (can_move && _is_action_pressed("left")) or automove_to == AutomoveDirection.LEFT:
		return Direction.LEFT

	return Direction.NONE


func should_jump() -> bool:
	return can_jump && Input.is_action_just_pressed("player_jump")


func die() -> void:
	PlayerStats.health = 0
	is_dead = true


func _is_action_pressed(direction: String) -> bool:
	return Input.is_action_pressed("player_" + direction)


func _on_Area2D_area_shape_entered(body_id, body, body_shape, local_shape):
	if body.is_in_group("cat_food"):
		if PlayerStats.health < PlayerStats.max_health:
			PlayerStats.health += 1
		velocity += SPEED_STEP

	if body.is_in_group("human_food"):
		if velocity > 32:
			velocity -= SPEED_STEP
		else:
			die()

	if body.is_in_group("trash"):
		if PlayerStats.health <= 1:
			die()
		PlayerStats.health -= 1
