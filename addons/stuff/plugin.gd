tool
extends EditorPlugin
const PanelScene = preload("res://addons/stuff/DockStuff.tscn")
var panel

func _enter_tree():
	print("enter tree")
	panel = PanelScene.instance()
	panel.editor_interface = get_editor_interface()
	get_editor_interface().get_editor_viewport().add_child(panel)
	make_visible(false)

func has_main_screen():
	return true
func make_visible(visible):
	if panel:
		panel.visible = visible
		
func get_plugin_name():
	return "Main Screen Plugin"
func get_plugin_icon():
	var icon =  get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
	return icon
	
const MyData = preload("MyData.gd")
func handles(obj):
	return obj.has_method("custom_editor")
func edit(obj):
	panel.edit(obj)
	
func _exit_tree():
	print("exit tree")
	if panel:
		panel.queue_free()
