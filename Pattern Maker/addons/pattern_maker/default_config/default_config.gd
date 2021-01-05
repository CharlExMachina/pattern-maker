tool
extends Node

func get_default_pattern_collection() -> Dictionary:
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

func get_default_pattern() -> Dictionary:
	return {
		"cooldown_time": 1,
		"time_between_spawns": 1,
		"start_delay_in_seconds": 10,
		"spawn_rate": 100.0,
		"difficulty_settings": {
			"max_number_of_difficulty_increases": 7,
			"cooldown_factor": 25.0,
			"between_spawns_factor": 0.0,
			"thresholds": {
				"min_time_between_spawns": 0.5,
				"min_cooldown_time": 0
			}
		},
		"spawn_points": []
	}
