tool
extends Control


var editor_interface: EditorInterface

var editing_objects: Array = []
var editing_objects_names: PoolStringArray

var current_edit_object: int = -1
export(Array, Resource) var preview_objects setget set_preview_objects
func set_preview_objects(in_preview):
	preview_objects = in_preview
	var new_objects = Array()
	for elem in preview_objects:
		if elem:
			if elem.has_method("custom_editor"):
				new_objects.append(elem)
	editing_objects = new_objects
	refresh_objects_names()
	
func refresh_objects_names():
	editing_objects_names.resize(len(editing_objects))
	for obj_idx in len(editing_objects):
		
		var name = editing_objects[obj_idx].resource_path.get_file().get_basename()
		editing_objects_names[obj_idx] = name

func _process(delta):
	var sidebar: ImGui = $Sidebar
	var content: ImGui = $Content

	sidebar.begin()
	for idx in len(editing_objects):
		var obj_name = editing_objects_names[idx]
		if sidebar.button(obj_name):
			current_edit_object = idx

	var edited_obj: Resource = null
	if current_edit_object >= len(editing_objects):
		current_edit_object = len(editing_objects)-1
	if current_edit_object > -1:
		edited_obj = editing_objects[current_edit_object]
	if edited_obj:
		content.begin()
		content.set_dirty(false)
		edited_obj.custom_editor(content)

func edit(obj):
	current_edit_object = editing_objects.find(obj)
	if current_edit_object == -1:
		current_edit_object = len(editing_objects)
		editing_objects.append(obj)
	refresh_objects_names()

