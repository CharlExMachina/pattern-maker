tool
extends PanelContainer

signal deleted_pattern

var pattern_ref: Dictionary setget pattern_ref_set, pattern_ref_get

var position_row_res = preload("res://addons/pattern_maker/ui/positions_row/PositionsRow.tscn")

var current_pattern_item: Dictionary
var item_index: int setget item_index_set

func item_index_set(new_value: int) -> void:
	$UI/Data/Header/PatternName.text = "Pattern " + str(new_value)
	item_index = new_value

func pattern_ref_set(new_value: Dictionary) -> void:
	load_pattern_item_data(new_value)
	pattern_ref = new_value

func pattern_ref_get() -> Dictionary:
	var cooldown_time: float = $UI/Data/CooldownTime/SpinBox.value
	var time_between_spawns: float = $UI/Data/TimeBetweenSpawns/SpinBox.value
	var start_delay_in_seconds: float = $UI/Data/StartDelay/SpinBox.value
	var spawn_rate: float = $UI/Data/SpawnRate/HSlider.value

	var difficulty_settings = {}

	var max_number_of_difficulty_increases: int = $UI/Data/MaxDifficultyIncreases/SpinBox.value
	var cooldown_factor: float = $UI/Data/CooldownFactor/HSlider.value
	var between_spawns_factor: float = $UI/Data/BetweenSpawnsFactor/HSlider.value

	var thresholds = {}

	var min_time_between_spawns: float = $UI/Data/MinTimeBetweenSpawns/SpinBox.value
	var min_cooldown_time: float = $UI/Data/MinCooldownTime/SpinBox.value

	pattern_ref["cooldown_time"] = cooldown_time
	pattern_ref["time_between_spawns"] = time_between_spawns
	pattern_ref["start_delay_in_seconds"] = start_delay_in_seconds
	pattern_ref["spawn_rate"] = stepify(spawn_rate, 0.1)

	difficulty_settings["max_number_of_difficulty_increases"] = max_number_of_difficulty_increases
	difficulty_settings["cooldown_factor"] = stepify(cooldown_factor, 0.1)
	difficulty_settings["between_spawns_factor"] = stepify(between_spawns_factor, 0.1)

	thresholds["min_time_between_spawns"] = min_time_between_spawns
	thresholds["min_cooldown_time"] = min_cooldown_time

	difficulty_settings["thresholds"] = thresholds
	pattern_ref["difficulty_settings"] = difficulty_settings

	pattern_ref["spawn_points"] = []

	for position in $UI/Positions.get_children():
		var pos_data = position.get_position_data()
		pattern_ref["spawn_points"].append(pos_data)
	return pattern_ref

func load_pattern_item_data(data: Dictionary) -> void:
	$UI/Data/CooldownTime/SpinBox.value = data["cooldown_time"]
	$UI/Data/TimeBetweenSpawns/SpinBox.value = data["time_between_spawns"]
	$UI/Data/StartDelay/SpinBox.value = data["start_delay_in_seconds"]
	$UI/Data/SpawnRate/HSlider.value = data["spawn_rate"]
	$UI/Data/SpawnRate/Percentage.text = str(stepify(data["spawn_rate"], 0.1)) + "%"

	var difficulty_settings = data["difficulty_settings"]
	$UI/Data/MaxDifficultyIncreases/SpinBox.value = difficulty_settings["max_number_of_difficulty_increases"]
	$UI/Data/CooldownFactor/HSlider.value = difficulty_settings["cooldown_factor"]
	$UI/Data/CooldownFactor/Percentage.text = str(stepify(
				difficulty_settings["cooldown_factor"], 0.1)) + "%"
	$UI/Data/BetweenSpawnsFactor/HSlider.value = difficulty_settings["between_spawns_factor"]
	$UI/Data/BetweenSpawnsFactor/Percentage.text = str(stepify(
				difficulty_settings["between_spawns_factor"], 0.1)) + "%"

	var thresholds = difficulty_settings["thresholds"]
	$UI/Data/MinTimeBetweenSpawns/SpinBox.value = thresholds["min_time_between_spawns"]
	$UI/Data/MinCooldownTime/SpinBox.value = thresholds["min_cooldown_time"]

	var positions: Array = data["spawn_points"]
	for position in positions:
		var instance = position_row_res.instance()
		instance.init_values(position["type"], position["position"])
		$UI/Positions.add_child(instance)

func _on_AddPositionsRow_pressed() -> void:
	var instance = position_row_res.instance()
	$UI/Positions.add_child(instance)
	var spawn_points: Array = pattern_ref["spawn_points"]
	spawn_points.append({
		"position": null,
		"type": "fruit"
	})
	# TODO: Connect instance signal with me!

func _on_SpawnRate_value_changed(value: float) -> void:
	$UI/Data/SpawnRate/Percentage.text = str(stepify(value, 0.1)) + "%"

func _on_CooldownFactor_value_changed(value: float) -> void:
	$UI/Data/CooldownFactor/Percentage.text = str(stepify(value, 0.1)) + "%"

func _on_BetweenSpawnsFactor_value_changed(value: float) -> void:
		$UI/Data/BetweenSpawnsFactor/Percentage.text = str(stepify(value, 0.1)) + "%"

func _on_DeletePattern_pressed() -> void:
	queue_free()
