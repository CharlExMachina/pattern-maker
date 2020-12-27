extends PanelContainer

signal save_to_collection

var current_pattern_item: Dictionary
var item_index: int

func load_pattern_item_data(pattern_item: Dictionary, item_index: int) -> void:
	pass

func save_modified_data() -> void:
	emit_signal("save_to_collection", current_pattern_item, item_index)
