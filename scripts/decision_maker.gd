class_name DecisionMaker
extends Node


static func should_draw_gaps(_width: int, index: int, total: int) -> bool:
	var last_section_index = total - 1

	match index:
		-1, 0, last_section_index:
			return false
		_:
			return true
