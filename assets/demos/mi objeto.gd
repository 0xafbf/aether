extends Spatial


onready var imgui = VisualDebugger.imgui

var x = 5
var y = 8
var z = 3

func _process(delta):
	imgui.begin("datos")
	imgui.text("valor %s %s %s" % [x,y,z])
	if imgui.button("suma_x"):
		x += 1
	imgui.end()
