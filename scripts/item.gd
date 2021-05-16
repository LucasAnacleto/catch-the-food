extends Area2D


func _ready():
	connect("body_shape_entered", self, "_on_body_shape_entered")


func _on_body_shape_entered(body_id, body, body_shape, local_shape):
	queue_free()
