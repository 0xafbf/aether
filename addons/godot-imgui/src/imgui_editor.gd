extends ImGui
tool
class_name ImGuiEditor

var editor_interface

func _process(delta):
	if not visible:
		return
	._process(delta)
	imgui_editor(editor_interface)

func imgui_editor(editor: EditorInterface):
	pass
