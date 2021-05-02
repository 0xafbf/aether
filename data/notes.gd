tool
extends Resource

var Note = preload("res://data/note.gd")

export var notes: PoolStringArray = []

export var notes2: Array = []

func custom_editor(imgui: ImGui):
	imgui.begin()
	imgui.text("total notes: %s" % len(notes))	
	
	if imgui.button("Add note2"):
		notes2.append(Note.new())
	
	var num_notes2 = len(notes2)
	for idx in num_notes2:
		var note = notes2[idx]
		note.text = imgui.input_text("note2_%d"%idx, note.text)
		imgui.same_line()
		note.done = imgui.checkbox("done", note.done)
		
		note.direction = imgui.button_group("type", Note.Direction, note.direction)
	
	if imgui.button("Add Note"):
		notes.append("")

	if imgui.get_dirty():
		property_list_changed_notify()
	return
###########################3
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
