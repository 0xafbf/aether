extends Resource
# we give it a class_name so we can create one resource from this
# we prefix ImGuiDemo to avoid confusions
class_name ImGuiDemo_Weapon
# we need to set it as tool to work
tool

enum WeaponType {
	Cutting,
	Piercing,
	Punching,
}

export var name := "Name"
export var description := "Description"
export var image: Texture
export var type := WeaponType.Cutting

export var abilities := [] # references to ability objects
var Ability = preload("res://addons/godot_imgui/samples/resource_editor/ability.gd")

func custom_editor(imgui: ImGui):
	imgui.begin()
	imgui.text("Demo data structure")
	
	imgui.text("items: %s" % len(abilities))
	imgui.same_line()
		
	if imgui.button("+"):
		var new_ability = Ability.new()
		abilities.append(null)
	var remove_idx := -1
	for idx in len(abilities):
		if imgui.button("X"):
			remove_idx = idx
		imgui.same_line()
		imgui.ref(abilities, idx, Ability)
	if remove_idx != -1:
		abilities.remove(remove_idx)
	if imgui.dirty:
		property_list_changed_notify()
	
	
