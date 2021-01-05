tool
extends VBoxContainer

signal create_pattern_collection
signal open_pattern_collection
signal save_changes
signal add_pattern

onready var time_to_start_spawning = $Layout/Props/TimeToStartSpawning/SpinBox
onready var base_fall_speed = $Layout/Props/BaseFallSpeed/SpinBox
onready var fall_speed_increase_value = $Layout/Props/FallSpeedIncreaseValue/SpinBox
onready var max_number_of_speed_increases = $Layout/Props/MaxSpeedIncreases/SpinBox
onready var max_fall_speed_allowed = $Layout/Props/MaxFallSpeedAllowed/SpinBox

func load_difficulty_settings(settings: Dictionary) -> void:
	var fall_speed_increase_ref: float = settings["fall_speed_increase_value"]
	var max_number_of_speed_increases_ref: int = settings["max_number_of_speed_increases"]
	var max_fall_speed_allowed_ref: float = settings["max_fall_speed_allowed"]

	fall_speed_increase_value.value = fall_speed_increase_ref
	max_number_of_speed_increases.value = max_number_of_speed_increases_ref
	max_fall_speed_allowed.value = max_fall_speed_allowed_ref

func load_spawning_properties(props: Dictionary) -> void:
	var time_to_start_spawning_ref: int = props["time_to_start_spawning"]
	var base_fall_speed_ref: int = props["base_fall_speed"]

	time_to_start_spawning.value = time_to_start_spawning_ref
	base_fall_speed.value = base_fall_speed_ref

func set_pattern_path(path: String) -> void:
	$Layout/PatternCollection.show()
	$Layout/PatternCollection.text += " " + path

func hide_save_button() -> void:
	$Layout/ToolBox/SaveChanges.hide()

func display_save_button() -> void:
	$Layout/ToolBox/SaveChanges.show()

func update_data(pattern_collection: Dictionary) -> void:
	var spawning_props = pattern_collection["spawning_properties"]
	spawning_props["time_to_start_spawning"] = time_to_start_spawning.value
	spawning_props["base_fall_speed"] = base_fall_speed.value

	var diff_settings = pattern_collection["difficulty_settings"]
	diff_settings["fall_speed_increase_value"] = fall_speed_increase_value.value
	diff_settings["max_number_of_speed_increases"] = max_number_of_speed_increases.value
	diff_settings["max_fall_speed_allowed"] = max_fall_speed_allowed.value

func hide_controls() -> void:
	$Layout/Props.hide()
	$Layout/Bottom.hide()

func display_controls() -> void:
	$Layout/Props.show()
	$Layout/Bottom.show()

func _on_CreatePatternCollection_pressed() -> void:
	emit_signal("create_pattern_collection")

func _on_LoadPattern_pressed() -> void:
	emit_signal("open_pattern_collection")

func _on_SaveChanges_pressed() -> void:
	emit_signal("save_changes")

func _on_AddPattern_pressed() -> void:
	emit_signal("add_pattern")
