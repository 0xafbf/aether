tool
extends ImGui



func _process(delta):
	._process(delta)
	begin()
	text("texto")
	if button("boton"):
		print("yay")
