tool
extends VBoxContainer

func _ready() -> void:
	$Button/PopupMenu.add_item("Fruit")
	$Button/PopupMenu.add_item("Bomb")

func _on_Button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_RIGHT:
				$PopupMenu.set_as_toplevel(false)
				$Button/PopupMenu.popup($Button.rect_global_position)
