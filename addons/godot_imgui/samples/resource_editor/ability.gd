extends Resource
# we give it a class_name so we can create one resource from this
# we prefix ImGuiDemo to avoid confusions
class_name ImGuiDemo_Ability
# we need to set it as tool to work
tool

enum AbilityType {
	Fire,
	Ice,
	Electric,
	Rock,
}

export var name = "Pyro"
export var description = "Fires a fire ball"
export var image: Texture
export var type = AbilityType.Fire
export var damage := 5.0

func custom_editor(imgui: ImGui):
	imgui.begin()
	imgui.text("Ability")
	imgui.input_textref(self, "name")
	imgui.input_textref(self, "description")
	imgui.ref(self, "image", Texture)
	type = imgui.button_group("type", AbilityType, type)
	if imgui.dirty:
		property_list_changed_notify()
	
	
