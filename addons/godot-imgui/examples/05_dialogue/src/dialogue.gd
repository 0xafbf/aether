extends Resource
tool
class_name Dialogue
const Line_Class = preload("res://addons/godot-imgui/examples/05_dialogue/src/dialogue_line.gd")
const Character_Class = preload("res://addons/godot-imgui/examples/05_dialogue/src/dialogue_character.gd")
export var lines: Array

func custom_editor(imgui: ImGui):
	imgui.begin()
	imgui.text("Lines:")
	var delete_idx = -1;
	for line_idx in len(lines):
		imgui.push_id(line_idx)
		if imgui.button("X"):
			delete_idx = line_idx
		imgui.same_line()
		if imgui.button(str(line_idx)):
			OS.clipboard = str(line_idx)
		imgui.same_line()

		var line = lines[line_idx]
		imgui.button_group_ref(line, "line_type", Line_Class.Line_Type)
		imgui.same_line()
		imgui.ref(line, "character", Character_Class)
		
		imgui.input_textref(line, "text")
		
		if line.line_type == Line_Class.Line_Type.Choice:
			var opt_to_delete = -1
			for opt_idx in len(line.options):
				if imgui.button("X"):
					opt_to_delete = opt_idx
				imgui.same_line()
				line.options[opt_idx] = imgui.input_text("opt%s %s"%[line_idx,opt_idx], line.options[opt_idx])
			if opt_to_delete != -1:
				(line.options as Array).remove(opt_to_delete)
		
			if imgui.button("add option%s"%line_idx):
				print("appending")
				line.options.append("")
		imgui.pop_id()
		
	if delete_idx != -1:
		lines.remove(delete_idx)
	if imgui.button("+"):
		lines.append(Line_Class.new())
	if imgui.dirty:
		property_list_changed_notify()
