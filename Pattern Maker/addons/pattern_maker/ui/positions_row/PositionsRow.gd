tool
extends HBoxContainer

func _ready() -> void:
	for position_button in get_children():
		position_button.connect("changed_spawn_type", self,
				"_on_position_button_changed_spawn_type")

func _on_position_button_changed_spawn_type(spawn_item: String,
		position_value: int) -> void:
#	match position_value:
#			0: #left
#				$Label.text = "Left"
#			1: #right
#				$Label.text = "Right"
#			2: #center
#				$Label.text = "Center"
#			3: #random
#				$Label.text = "Random"

	for position_button in get_children():
		if position_button.position_value != position_value:
			position_button.reset_values()

	print(spawn_item)
	pass

func _on_Delete_pressed() -> void:
	queue_free()
