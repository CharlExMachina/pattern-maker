tool
extends HBoxContainer

var position_type: String
var position_value: String

func _ready() -> void:
	for position_button in get_children():
		if position_button.name != "Delete":
			position_button.connect("changed_spawn_type", self,
					"_on_position_button_changed_spawn_type")

func get_position_data() -> Dictionary:
	return {
		"position": position_value,
		"type": position_type
	}

func init_values(type: String, value: String) -> void:
	position_type = type
	position_value = value

	if (value == "left"):
		$PositionButton_L.activate_position(type)
	elif (value == "center"):
		$PositionButton_C.activate_position(type)
	elif (value == "right"):
		$PositionButton_R.activate_position(type)
	elif (value == "random"):
		$PositionButton_RND.activate_position(type)

func _on_position_button_changed_spawn_type(spawn_item: String,
		pos_value: int) -> void:
	match pos_value:
			0: #left
				position_value = "left"
			1: #right
				position_value = "right"
			2: #center
				position_value = "center"
			3: #random
				position_value = "random"

	position_type = spawn_item

	for position_button in get_children():
		if position_button.name != "Delete" and position_button.position_value != pos_value:
			position_button.reset_values()

func _on_Delete_pressed() -> void:
	queue_free()
