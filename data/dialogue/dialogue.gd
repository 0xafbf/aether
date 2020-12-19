extends Resource
tool
class_name Dialogue
const Line_Class = preload("res://data/dialogue/dialogue_line.gd")
export var lines: Array



func custom_editor(imgui: ImGui):
	imgui.begin()
	imgui.text("Lines:")
	for line_idx in len(lines):
		imgui.text("Line: %d" % line_idx)
		var line = lines[line_idx]
		line.text = imgui.input_text(str(line), line.text)
		line.mood = imgui.tabs(Line_Class.Character_Mood))
	if imgui.button("+"):
		lines.append(Line_Class.new())
