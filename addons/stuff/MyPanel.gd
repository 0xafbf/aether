tool
extends Control

onready var sidebar: ImGui = $Sidebar
onready var content: ImGui = $Content

var editor_interface: EditorInterface

var editing_objects: Array = []
var current_edit_object: int = -1

func _enter_tree():
	print("enter tree")

func _process(delta):
	
	sidebar.begin("Files")
	for idx in len(editing_objects):
		var obj: Resource = editing_objects[idx]
		if sidebar.button(obj.resource_path):
			current_edit_object = idx
	sidebar.end()
	
	var edited_obj: Resource = null
	if current_edit_object > len(editing_objects):
		current_edit_object = len(editing_objects)-1
	if current_edit_object > -1:
		edited_obj = editing_objects[current_edit_object]
	if edited_obj:
		content.begin(edited_obj.resource_path)
		content.set_dirty(false)
		edited_obj.custom_editor(content)
		content.end()
			
func edit(obj):
	current_edit_object = editing_objects.find(obj)
	if current_edit_object == -1:
		current_edit_object = len(editing_objects)
		editing_objects.append(obj)

