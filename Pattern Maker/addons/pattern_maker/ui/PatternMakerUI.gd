tool
extends Control

onready var create_pattern_collection_dialog = $CreatePatternDialog
onready var open_pattern_collection_file_dialog = $OpenPatternDialog

var current_pattern_collection_path
var current_pattern_collection

func _ready() -> void:
	create_pattern_collection_dialog.get_ok().text = "Save pattern collection"
	pass

func create_pattern_file() -> void:
	var save_dir = create_pattern_collection_dialog.current_dir + "/"
	var file_name = create_pattern_collection_dialog.get_line_edit().text
	var extension = ".pattern"

	if not ".pattern" in file_name:
		file_name += extension

	var base_pattern_dict: Dictionary = get_base_config()
	var json_config: String = JSON.print(base_pattern_dict)

	var path = save_dir + file_name
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(json_config)
	file.close()

func open_file(path: String) -> void:
	var file = File.new()
	file.open(path, File.READ)
	var content: String = file.get_as_text()
	var pattern_data: Dictionary = JSON.parse(content).result
	current_pattern_collection = pattern_data
	load_pattern_collection_to_editor(current_pattern_collection)
	current_pattern_collection_path = path
	pass

func load_pattern_collection_to_editor(pattern_data: Dictionary) -> void:
	var spawning_properties: Dictionary = pattern_data["spawning_properties"]
	var difficulty_settings: Dictionary = pattern_data["difficulty_settings"]

	set_spawning_props(spawning_properties)
	set_difficulty_settings(difficulty_settings)

func set_spawning_props(props: Dictionary) -> void:
	var time_to_start_spawning: int = props["time_to_start_spawning"]
	var base_fall_speed: int = props["base_fall_speed"]
	$Scroll/UI/Settings/Layout/Props/TimeToStartSpawning/SpinBox.value = time_to_start_spawning
	$Scroll/UI/Settings/Layout/Props/BaseFallSpeed/SpinBox.value = base_fall_speed

func set_difficulty_settings(settings: Dictionary) -> void:
	var fall_speed_increase_value: float = settings["fall_speed_increase_value"]
	var max_number_of_speed_increases: int = settings["max_number_of_speed_increases"]
	var max_fall_speed_allowed: float = settings["max_fall_speed_allowed"]
	$Scroll/UI/Settings/Layout/Props/FallSpeedIncreaseValue/SpinBox.value = fall_speed_increase_value
	$Scroll/UI/Settings/Layout/Props/MaxSpeedIncreases/SpinBox.value = max_number_of_speed_increases
	$Scroll/UI/Settings/Layout/Props/MaxFallSpeedAllowed/SpinBox.value = max_fall_speed_allowed

func get_base_config() -> Dictionary:
	return {
		"spawning_properties": {
			"time_to_start_spawning": 5,
			"base_fall_speed": 7
		},
		"difficulty_settings": {
			"fall_speed_increase_value": 1,
			"max_number_of_speed_increases": 2,
			"max_fall_speed_allowed": 12
		},
		"patterns": []
	}

func _on_CreatePatternCollection_pressed() -> void:
	create_pattern_collection_dialog.popup_centered()

func _on_CreatePatternDialog_file_selected(path: String) -> void:
	create_pattern_file()

func _on_LoadPattern_pressed() -> void:
	open_pattern_collection_file_dialog.popup_centered()

func _on_OpenPatternDialog_file_selected(path: String) -> void:
	open_file(path)
