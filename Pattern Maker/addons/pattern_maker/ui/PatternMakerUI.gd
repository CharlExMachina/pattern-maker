tool
extends Control

onready var create_pattern_collection_dialog = $CreatePatternDialog
onready var open_pattern_collection_file_dialog = $OpenPatternDialog

var current_pattern_collection_path: String
var current_pattern_collection: Dictionary

var pattern_res = preload("res://addons/pattern_maker/ui/pattern/Pattern.tscn")
var default_pattern_values = preload("res://addons/pattern_maker/default_config/default_config.gd").new()

func _ready() -> void:
	create_pattern_collection_dialog.get_ok().text = "Save pattern collection"
	display_alert()

func cleanup_patterns_in_gui() -> void:
	var patterns_container = $Scroll/UI/Patterns
	for child in patterns_container.get_children():
		child.queue_free()

func display_alert() -> void:
	if current_pattern_collection.empty() and current_pattern_collection_path.empty():
		$Scroll/UI/Settings.hide_controls()
		$NoCollectionAlert.show()

func hide_alert() -> void:
	$NoCollectionAlert.hide()
	$Scroll/UI/Settings.display_controls()

# TODO: Set the newly created pattern to be the one edited at the moment
func create_pattern_file() -> void:
	var save_dir = create_pattern_collection_dialog.current_dir + "/"
	var file_name = create_pattern_collection_dialog.get_line_edit().text
	var extension = ".pattern"

	if not ".pattern" in file_name:
		file_name += extension

	var base_pattern_collection: Dictionary = default_pattern_values.get_default_pattern_collection()
	var json_config: String = JSON.print(base_pattern_collection)

	var path = save_dir + file_name
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(json_config)
	file.close()
	create_pattern_collection_dialog.hide()

	open_pattern_collection_file(path)

func open_pattern_collection_file(path: String) -> void:
	var file = File.new()
	file.open(path, File.READ)
	var content: String = file.get_as_text()
	var pattern_data: Dictionary = JSON.parse(content).result

	current_pattern_collection = pattern_data
	current_pattern_collection_path = path

	hide_alert()

	load_pattern_collection_to_editor(current_pattern_collection)
	cleanup_patterns_in_gui()
	display_patterns()
	pass

func load_pattern_collection_to_editor(pattern_data: Dictionary) -> void:
	var spawning_properties: Dictionary = pattern_data["spawning_properties"]
	var difficulty_settings: Dictionary = pattern_data["difficulty_settings"]

	set_spawning_props(spawning_properties)
	set_difficulty_settings(difficulty_settings)

func set_spawning_props(props: Dictionary) -> void:
	$Scroll/UI/Settings.load_spawning_properties(props)

func set_difficulty_settings(settings: Dictionary) -> void:
	$Scroll/UI/Settings.load_difficulty_settings(settings)

func display_patterns() -> void:
	print(current_pattern_collection)
	var patterns: Array = current_pattern_collection["patterns"]

	for pattern in patterns:
		var pattern_display_instance = pattern_res.instance()
		var patterns_container = $Scroll/UI/Patterns

		if patterns.find(pattern) + 1 > patterns_container.get_child_count():
			patterns_container.add_child(pattern_display_instance)

func _on_CreatePatternDialog_file_selected(path: String) -> void:
	create_pattern_file()

func _on_OpenPatternDialog_file_selected(path: String) -> void:
	open_pattern_collection_file(path)

func _on_AddPattern_pressed() -> void:
	var patterns: Array = current_pattern_collection["patterns"]
	patterns.append(default_pattern_values.get_default_pattern())
	current_pattern_collection["patterns"] = patterns

	display_patterns()

func _on_Settings_create_pattern_collection() -> void:
	create_pattern_collection_dialog.popup_centered()

func _on_Settings_open_pattern_collection() -> void:
	open_pattern_collection_file_dialog.popup_centered()

func _on_Settings_save_changes() -> void:
	$Scroll/UI/Settings.update_data(current_pattern_collection)
	var json = JSON.print(current_pattern_collection)
	var file: File = File.new()
	file.open(current_pattern_collection_path, File.WRITE)
	file.store_string(json)
	file.close()
