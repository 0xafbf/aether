extends ImGuiEditor

var cantidad = 0

func imgui_editor(editor: EditorInterface):
	begin()
	
	if button("saludar"):
		cantidad += 1
		
	text("Hola x %s" % cantidad)
		
		
