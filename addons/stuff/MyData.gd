extends Resource
tool
class_name MyData

export var a: float = 1
export var name: String = "abc"
enum MyEnum { A, B }

export(Array, int) var values = []


func custom_editor(imgui: ImGui):
	imgui.text(name)
	imgui.text("array count:  %s" % len(values))
	if imgui.button("decir Hola"):
		print("hola")
	
	if imgui.button("Add"):
		values.append(0)
	var remove_idx = -1
	for idx in len(values):
		if imgui.button("x"):
			remove_idx = idx
		imgui.same_line()
		if imgui.button("+"):
			values[idx] += 1
		imgui.same_line()
		if imgui.button("-"):
			values[idx] -= 1
		imgui.same_line()
		if imgui.button("x2"):
			values[idx] *= 2
		imgui.same_line()
		
		imgui.text("Value %s: %s" % [idx, values[idx]])
	if remove_idx != -1:
		values.remove(remove_idx)
	
	if imgui.get_dirty():
		property_list_changed_notify()
