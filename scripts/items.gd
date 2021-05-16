extends Node


export(Array, String, FILE, "*.tscn") var item_file_paths

var _item_types := {}
var _last_item_type_name: String


func _ready():
	randomize()

	for item_file_path in item_file_paths:
		var item_name: String = item_file_path.get_file().get_basename().to_lower()
		var item := load(item_file_path)

		_item_types[item_name] = item


func spawn(platform_size: int, cell_size: Vector2, base_position: Vector2) -> void:
	var normalized_base_position := base_position - (cell_size / 2)
	var next_item_type := _get_next_item_type()
	var next_items := []
	var screen_width := get_viewport().size.x
	var current_platforms_width := base_position.x

	if not next_item_type.name == "trash":
		return

	if base_position.x >= screen_width * 2:
		var item = next_item_type.scene.instance()
		item.position = normalized_base_position
		add_child(item)


func _get_next_item_type() -> Dictionary:
	var item_type_names := _item_types.keys()
	var next_item_type_name := _last_item_type_name

	while next_item_type_name == _last_item_type_name:
		next_item_type_name = item_type_names[randi() % item_type_names.size()]

	_last_item_type_name = next_item_type_name

	return {
		"name": next_item_type_name,
		"scene": _item_types[next_item_type_name],
	}


func _on_Platforms_platform_generated(platform_size: int, cell_size: Vector2, last_cell_position: Vector2):
	if platform_size > 3:
		spawn(platform_size, cell_size, last_cell_position)
