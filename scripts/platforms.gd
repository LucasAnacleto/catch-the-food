extends TileMap


signal platform_generated(part_size, cell_size, last_cell_position)


export var start_row := 0

onready var current_wall_tile := tile_set.find_tile_by_name("brick")
onready var platform_gap_tile := tile_set.find_tile_by_name("water-top")


func _on_PlatformSectionGenerator_draw_platform_requested(section: Dictionary):
	var start_column: int = section.units * section.index

	for part in section.parts:
		var part_tile: int

		match part.type:
			"platform":
				part_tile = current_wall_tile
			"gap":
				part_tile = platform_gap_tile

		for x in range(start_column, start_column + part.size):
			set_cellv(Vector2(x, start_row), part_tile)

		start_column += part.size

		if part.type == "platform":
			emit_signal("platform_generated", part.size, cell_size,
					map_to_world(Vector2(start_column - 1, start_row)))


func _on_PlatformGenerator_map_clear_requested():
	clear()
