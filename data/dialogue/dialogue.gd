extends Resource
tool
class_name Dialogue
const Line_Class = preload("res://data/dialogue/dialogue_line.gd")
const Character_Class = preload("res://data/dialogue/dialogue_character.gd")
export var lines: Array


func custom_editor(imgui: ImGui):
	imgui.begin()
	imgui.text("Lines:")
	for line_idx in len(lines):
		if imgui.button(str(line_idx)):
			OS.clipboard = str(line_idx)
		imgui.same_line()
		var line = lines[line_idx]
		if imgui.ref(line, "character", Character_Class):
			print("changed")
		imgui.same_line()
		line.text = imgui.input_text(str(line), line.text)
		imgui.same_line()
		line.mood = imgui.button_group("Line Type", Line_Class.Line_Type, line.mood)

		var opt_to_delete = -1
		for opt_idx in len(line.options):			
			if imgui.button("X"):
				opt_to_delete = opt_idx
			imgui.same_line()
			line.options[opt_idx] = imgui.input_text("opt%s %s"%[line_idx,opt_idx], line.options[opt_idx])
		if opt_to_delete != -1:
			(line.options as Array).remove(opt_to_delete)
		
		if imgui.button("add option%s"%line_idx):
			line.options.append("")
		
	if imgui.button("+"):
		lines.append(Line_Class.new())
