extends ImGui
tool
class_name ImGuiEditor

var editor_interface

func _ready():
	print("%s _ready" % get_class())
	
func _enter_tree():
	
	print("%s _enter_tree" % get_class())
	._enter_tree()

func _process(delta):
	if not visible:
		return
	._process(delta)
	imgui_editor(editor_interface)

func imgui_editor(editor: EditorInterface):
	pass
