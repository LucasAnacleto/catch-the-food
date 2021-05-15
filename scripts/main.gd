extends Node2D


onready var map_width := int(get_viewport().size.x * 20)
onready var map_generator := $PlatformGenerator as PlatformMapGenerator


func _ready():
	map_generator.generate_map(map_width)
