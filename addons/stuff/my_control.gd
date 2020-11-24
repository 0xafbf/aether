tool
extends ImGui



func _process(delta):
	._process(delta)
	begin("hola")
	text("texto")
	if button("boton"):
		print("yay")
	end()
