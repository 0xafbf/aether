tool
extends Resource
class_name Note
export var notes: PoolStringArray = []

func custom_editor(imgui: ImGui):

	imgui.text("total notes: %s" % len(notes))	
	if imgui.button("Add Note"):
		notes.append("")

	var num_notes = len(notes)
	for idx in num_notes:
		#imgui.push_id(idx)
		if (idx -1) >= 0 :
			if imgui.button("^"):
				var buf = notes[idx-1]
				notes[idx-1] = notes[idx]
				notes[idx] = buf
			imgui.same_line()
			
		if (idx+1) < num_notes:
			if imgui.button("V"):
				var buf = notes[idx+1]
				notes[idx+1] = notes[idx]
				notes[idx] = buf
			imgui.same_line()
			
		var note = notes[idx]
		note = imgui.input_text("content%s" % idx, note)
		notes[idx] = note
		#imgui.pop_id()
	if imgui.get_dirty():
		property_list_changed_notify()
