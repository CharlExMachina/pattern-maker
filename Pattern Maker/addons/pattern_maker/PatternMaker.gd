tool
extends EditorPlugin

var plugin_res = preload("res://addons/pattern_maker/ui/PatternMakerUI.tscn")

var plugin_ui

func _enter_tree() -> void:
	init_pattern_editor()


func _exit_tree() -> void:
	remove_control_from_bottom_panel(plugin_ui)
	plugin_ui = null

func init_pattern_editor() -> void:
#	var selection: Array = get_editor_interface().get_selection().get_selected_nodes()
#	if selection.size() == 1:
#		var selected_node = selection[0]
#		if selected_node.name == "Spawner":
	plugin_ui = plugin_res.instance()
	add_control_to_bottom_panel(plugin_ui, "Pattern Editor")
