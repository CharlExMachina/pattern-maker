tool
extends Control

var current_pattern_collection_path: String
var current_pattern_collection: Dictionary

var pattern_res = preload("res://addons/pattern_maker/ui/pattern/Pattern.tscn")
var default_pattern_values = preload("res://addons/pattern_maker/default_config/default_config.gd").new()

func _ready() -> void:
	$CreatePatternDialog.get_ok().text = "Save pattern collection"
	display_alert()
	if current_pattern_collection.empty():
		$Scroll/UI/Settings.hide_save_button()

func display_alert() -> void:
	if current_pattern_collection.empty() and current_pattern_collection_path.empty():
		$Scroll/UI/Settings.hide_controls()
		$NoCollectionAlert.show()

func cleanup_patterns_in_gui() -> void:
	var patterns_container = $Scroll/UI/Patterns
	for child in patterns_container.get_children():
		child.free()

func hide_alert() -> void:
	$NoCollectionAlert.hide()
	$Scroll/UI/Settings.display_controls()

func create_pattern_file() -> void:
	var save_dir = $CreatePatternDialog.current_dir + "/"
	var file_name = $CreatePatternDialog.get_line_edit().text
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
	$CreatePatternDialog.hide()

	open_pattern_collection_file(path)

func open_pattern_collection_file(path: String) -> void:
	hide_alert()
	cleanup_data()
	cleanup_patterns_in_gui()

	var file = File.new()
	file.open(path, File.READ)
	var content: String = file.get_as_text()
	var pattern_data: Dictionary = JSON.parse(content).result

	current_pattern_collection = pattern_data
	current_pattern_collection_path = path
	$Scroll/UI/Settings.display_save_button()

	display_patterns()
	load_pattern_collection_to_editor(current_pattern_collection)
	pass

func load_pattern_collection_to_editor(pattern_data: Dictionary) -> void:
	var spawning_properties: Dictionary = pattern_data["spawning_properties"]
	var difficulty_settings: Dictionary = pattern_data["difficulty_settings"]

	set_spawning_props(spawning_properties)
	set_difficulty_settings(difficulty_settings)
	$Scroll/UI/Settings.set_pattern_path(current_pattern_collection_path)

func set_spawning_props(props: Dictionary) -> void:
	$Scroll/UI/Settings.load_spawning_properties(props)

func set_difficulty_settings(settings: Dictionary) -> void:
	$Scroll/UI/Settings.load_difficulty_settings(settings)

func display_patterns() -> void:
	var patterns: Array = current_pattern_collection["patterns"]

	print($Scroll/UI/Patterns.get_child_count())

	for i in patterns.size():
		var pattern_display_instance = pattern_res.instance()
		var patterns_container = $Scroll/UI/Patterns

		if i == patterns_container.get_child_count(): # if we're at the end of the list
			pattern_display_instance.pattern_ref = patterns[i]
			pattern_display_instance.item_index = i + 1
			patterns_container.add_child(pattern_display_instance)
#
#		if i + 1 > patterns_container.get_child_count():
#			pattern_display_instance.pattern_ref = patterns[i]
#			pattern_display_instance.item_index = i + 1
#			patterns_container.add_child(pattern_display_instance)
# TODO: return here!
#	for pattern in patterns:
#		var pattern_display_instance = pattern_res.instance()
#		var patterns_container = $Scroll/UI/Patterns
#
#		if patterns.find(pattern) + 1 > patterns_container.get_child_count():
#			pattern_display_instance.pattern_ref = patterns[patterns.find(pattern)]
#			pattern_display_instance.item_index = patterns.find(pattern) + 1
#			patterns_container.add_child(pattern_display_instance)

func cleanup_data() -> void:
	current_pattern_collection_path = ""
	current_pattern_collection = {}

func _on_CreatePatternDialog_file_selected(path: String) -> void:
	create_pattern_file()

func _on_OpenPatternDialog_file_selected(path: String) -> void:
	open_pattern_collection_file(path)

func _on_AddPattern_pressed() -> void:
	var patterns: Array = current_pattern_collection["patterns"]
	patterns.append(default_pattern_values.get_default_pattern())
	current_pattern_collection["patterns"] = patterns

	display_patterns()

func update_patterns() -> void:
	current_pattern_collection["patterns"] = []
	for pattern in $Scroll/UI/Patterns.get_children():
		var ref = pattern.pattern_ref
		current_pattern_collection["patterns"].append(ref)

func _on_Settings_create_pattern_collection() -> void:
	$CreatePatternDialog.popup_centered()

func _on_Settings_open_pattern_collection() -> void:
	$OpenPatternDialog.popup_centered()

func _on_Settings_save_changes() -> void:
	if current_pattern_collection.empty():
		return

	$Scroll/UI/Settings.update_data(current_pattern_collection)
	update_patterns()
	var json = JSON.print(current_pattern_collection)
	var file: File = File.new()
	file.open(current_pattern_collection_path, File.WRITE)
	file.store_string(json)
	file.close()

func _on_Settings_add_pattern() -> void:
	var default_pattern = default_pattern_values.get_default_pattern()
	var patterns: Array = current_pattern_collection["patterns"]
	patterns.append(default_pattern)
	display_patterns()
