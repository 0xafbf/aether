extends Node

onready var imgui: ImGui = VisualDebugger.imgui

var count = 0
var scores = [3, 5, 6]
var demo_text = "hola"

func _process(_delta):
	
	imgui.begin()

	
	var mouse_position2 = get_viewport().get_mouse_position()
	imgui.text("mouse: %s" % mouse_position2)
	
	
	demo_text = imgui.input_text("mi_texto", demo_text)
	imgui.text(demo_text)
	
	for idx in len(scores):
		imgui.text("scoe: %d" % scores[idx])
		imgui.same_line()
		if imgui.button("-"):
			scores[idx] -= 1
		imgui.same_line()
		if imgui.button("+"):
			scores[idx] += 1
		
	
	if imgui.button("mi boton"):
		scores.append(5)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	return
	var mouse_position = get_viewport().get_mouse_position()
	
	imgui.begin()
	
	var fps = 0
	if _delta != 0:
		fps = 1/_delta
	imgui.text("FPS: %f" % fps)
	imgui.text("input demo:")
	demo_text = imgui.input_text("name", demo_text)
	imgui.text("hola, %s!" % demo_text)
	
	imgui.text("mouse: %f %f" % [mouse_position.x, mouse_position.y])
	imgui.text("num scores:  %d" % len(scores))
	if imgui.button("add score"):
		scores.append(0)
		
	for idx in len(scores):
		if imgui.button("+"):
			scores[idx] += 1
		imgui.same_line()
		if imgui.button("-"):
			scores[idx] -= 1
		
		imgui.same_line()
		imgui.text("score %d: %d" % [idx, scores[idx]])
