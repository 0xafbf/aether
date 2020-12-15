tool
extends EditorPlugin
const PanelScene = preload("res://addons/stuff/DockStuff.tscn")
var panel

func _enter_tree():
	panel = PanelScene.instance()
	panel.editor_interface = get_editor_interface()
	get_editor_interface().get_editor_viewport().add_child(panel)
	make_visible(false)
	
	connect("resource_saved", self, "on_resource_saved")

var scripts = Dictionary()

func on_resource_saved(res):
	if res is Script:
		var s: Script = res as Script
		var name = s.resource_path
		if name in scripts.keys():
			return
		var methods  = s.get_script_method_list()
		for method in methods:
			if method.name == "imgui_editor":
				print("reloading '%s'"%name)
				var t = name.get_file()
				var o = s.new()
				o.editor_interface = get_editor_interface()
				scripts[name] = {
					"object": o,
					"title": t,
				}
				add_control_to_bottom_panel(o, t)
				break

func has_main_screen():
	return true
func make_visible(visible):
	if panel:
		panel.visible = visible
		
func get_plugin_name():
	return "Resources"
func get_plugin_icon():
	var icon =  get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
	return icon
	
func handles(obj):
	return obj.has_method("custom_editor")
	
func edit(obj):
	panel.edit(obj)
	
func _exit_tree():
	if panel:
		panel.queue_free()
	for s in scripts:
		var c = scripts[s]
		remove_control_from_bottom_panel(c.object)
