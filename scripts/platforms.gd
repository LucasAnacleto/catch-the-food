extends TileMap


signal platform_generated(part_size, cell_size, last_cell_position)


export var start_row := 0

onready var themes = [
	{
		"wall": "brick",
		"gap": "grid",
		"bg": Color(0.230469, 0.171951, 0.171951)
	},
	{
		"wall": "sand",
		"gap": "water",
		"bg": Color(0.433594, 0.694672, 1)
	}
]
onready var current_theme = _get_next_theme()


func _on_PlatformSectionGenerator_draw_platform_requested(section: Dictionary):
	var start_column: int = section.units * section.index

	for part in section.parts:
		var part_tile: int

		match part.type:
			"platform":
				part_tile = tile_set.find_tile_by_name(themes[current_theme].wall)
			"gap":
				part_tile = tile_set.find_tile_by_name(themes[current_theme].gap)

		for x in range(start_column, start_column + part.size):
			set_cellv(Vector2(x, start_row), part_tile)

		start_column += part.size

		if part.type == "platform":
			emit_signal("platform_generated", part.size, cell_size,
					map_to_world(Vector2(start_column - 1, start_row)))


func _get_next_theme() -> int:
	var next_theme = randi() % themes.size() - 1

	while next_theme == current_theme:
		next_theme = randi() % themes.size() - 1

	return next_theme


func _on_PlatformGenerator_map_clear_requested():
	current_theme = _get_next_theme()
	clear()


func _on_PlatformGenerator_map_generation_requested(_width):
	VisualServer.set_default_clear_color(themes[current_theme].bg)
