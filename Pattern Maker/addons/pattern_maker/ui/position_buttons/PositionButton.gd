tool
extends VBoxContainer

export(int, "Left", "Right", "Center", "Random") var position_value setget set_position_val

signal changed_spawn_type

const ACTIVE_COLOR: Color = Color(0.27, 0.57, 0.81)
const OFFSET: Vector2 = Vector2(50, 20)
const APPLE_ICON = preload("res://addons/pattern_maker/icons/apple_icon.png")
const BOMB_ICON = preload("res://addons/pattern_maker/icons/bomb_icon.png")
const NONE_ICON = preload("res://addons/pattern_maker/icons/none_dot_icon.png")

var is_active: bool = false
var current_spawn_item: String

func _ready() -> void:
	$PopupMenu.add_item("Fruit")
	$PopupMenu.add_item("Bomb")

func activate_position(type: String) -> void:
	if type == "fruit":
		current_spawn_item = "fruit"
		$Button.modulate = ACTIVE_COLOR
		update_spawn_item()
	elif type == "bomb":
		current_spawn_item = "bomb"
		$Button.modulate = ACTIVE_COLOR
		update_spawn_item()

func set_position_val(new_position: int) -> void:
	if position_value != new_position:
		match new_position:
			0:
				$Label.text = "Left"
			1:
				$Label.text = "Right"
			2:
				$Label.text = "Center"
			3:
				$Label.text = "Random"

		position_value = new_position
		update()

func _on_Button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_LEFT:
				if not is_active:
					is_active = true
					current_spawn_item = "fruit"
					$Button.modulate = ACTIVE_COLOR
					update_spawn_item()
			BUTTON_RIGHT:
				if is_active:
					var pos = rect_global_position + OFFSET
					$PopupMenu.popup(Rect2(pos, $PopupMenu.rect_size))

func update_spawn_item() -> void:
	if current_spawn_item == "fruit":
		$Button.texture_normal = APPLE_ICON
	elif current_spawn_item == "bomb":
		$Button.texture_normal = BOMB_ICON

	emit_signal("changed_spawn_type", current_spawn_item, position_value)


func reset_values() -> void:
	is_active = false
	$Button.texture_normal = NONE_ICON
	$Button.modulate = Color(1, 1, 1)

func _on_PopupMenu_id_pressed(id: int) -> void:
	if id == 0:
		current_spawn_item = "fruit"
		$Button.texture_normal = APPLE_ICON
	elif id == 1:
		current_spawn_item = "bomb"
		$Button.texture_normal = BOMB_ICON
