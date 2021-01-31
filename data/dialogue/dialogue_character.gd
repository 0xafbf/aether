extends Resource
tool
class_name Dialogue_Character
export var name: String = ""
export var face: Texture


func custom_preview(imgui: ImGui):
	imgui.image_sized(face, Vector2(24, 24))
	imgui.same_line()
	imgui.text(name)
	
func custom_editor(imgui: ImGui):
	name = imgui.input_text("name", name)
	imgui.image_sized(face, Vector2(100, 100))
	imgui.ref(self, "face", "Texture")
	

