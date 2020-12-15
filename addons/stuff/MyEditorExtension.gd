extends ImGuiEditor
tool

	
func imgui_editor(editor: EditorInterface):
	begin()
	if button("test"):
		var fs = editor.get_resource_filesystem()
		var path = editor.get_selected_path()
		print(path)
	text("hola")
	text("hola2")
	rect_size = Vector2(0, 50)
	

