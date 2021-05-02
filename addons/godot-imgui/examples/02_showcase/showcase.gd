extends ImGui
# You can use the tool keyword to make the UI work in edit mode.
tool

enum Alignment {
	Lawful,
	Neutral,
	Chaotic,
}

# Data used for the example below.
# wherever we use the fg letters, is to check for ascenders and descenders 
var username: String = "Sailor fg"
var alignment = Alignment.Lawful
var enabled := false

func _process(delta):

	begin()
	
	text("Godot ImGUI Showcase")
	text("======================")
	
	text("ABCXYZ123yyy")
	text("ABCXYZ123AAA")
	text("!@#$%&*+=")
	text("!@#$%&*+=")
	
	button("BUTTON1")
	button("BUTTON2")
	
	space(10)
	text("Text input:")
	username = input_text("username_noref", username)
	text("Hello, %s!" % username)
	
	space(10)
	# sometimes it is more convenient to do imgui calls with object references.
	# this allows to use the return value to notify change events
	text("Text input by reference:")
	if input_textref(self, "username"):
		print("textref changed")
	
	space(10)
	# we use fg to check for ascenders and descenders
	if button("Button fg"):
		print("Clicked!")
	
	space(10)
	text("layout with `sameline()`")
	text("click this button:")
	same_line()
	button("#")
	same_line()
	text(" or this button:")
	same_line()
	button("#")
	
	space(10)
	text("checkbox")
	enabled = checkbox("enabled", enabled)
	
	space(10)
	text("checkbox by ref")
	if checkbox_ref(self, "enabled"):
		print("checkbox! %s" % enabled)
	
	space(10)
	text("toggle")
	enabled = toggle("enabled", enabled)
	
	space(10)
	text("toggle by ref")
	if toggle_ref(self, "enabled"):
		print("toggled! %s" % enabled)
	
	space(10)
	text("Button Group")
	alignment = button_group("Line Type", Alignment, alignment)
	
	space(10)
	text("Button Group by reference")
	if button_group_ref(self, "alignment", Alignment):
		print("changed enum! %s" % alignment)

	
