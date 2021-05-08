extends ImGui
# You can use the tool keyword to make the UI work in edit mode.
# Open basic_scene.tscn to see a live view of this example without having
# to run it
tool

# Data used for the example below. 
var username: String = "Sailor"

# This array can have any number of items
# and the UI will adapt accordingly. You can add or remove items at runtime.
var scores: Array = [3, 5, 8]

# The UI is drawn by using the Control functions, you create the UI by calling
# `begin` and then calling the UI functions directly.

func _process(delta):

	# We need to call `begin` to clean up all the queued draw info.
	begin()
	
	text("Godot ImGUI basic demo")
	text("======================")
	text("This file shows the basic usage of Godot ImGUI. Refer to basic_imgui.gd")
	text("To see how this UI was generated.")
	
	space(10)
	text("To create a text widget just call the `text` function:")
	text("Hello, World!")
	
	space(10)
	text("Buttons can be created easily with the `button` function. You can")
	text("find if the button was clicked by checking the return value")
	
	if button("Print to console!"):
		print("Clicked!")
	
	space(10)
	text("You can see this UI drawn inside the editor because the script")
	text("has the `tool` keyword")
	
	space(10)
	text("You can add space to the UI layout with the `space` function")
	
	space(10)
	text("We can create text input widgets, by passing the current text and it")
	text("will return the new text")
	username = input_text("username_noref", username)
	text("Hello, %s!" % username)
	text("Keep in mind that although this script has the `tool` keyword, you")
	text("can't interact with text fields from the editor window.")
	
	"""
	space(10)
	text("some UI functions take references so they edit the data in-place")
	text("this works the same as the previous example, but uses an object")
	text("reference instead.")
	input_textref(self, "username")
	text("Hello, %s Ref!" % username)
	"""
	
	space(10)
	text("ImGUI techniques allow you to create dynamic UIs easily, just call")
	text("functions for UI elements with the desired data")
	var mouse_position = get_viewport().get_mouse_position()
	text("Mouse: %s" % mouse_position)
	
	
	space(10)
	text("ImGui makes it really easy to create UIs from dynamic data like")
	text("arrays. You can just iterate the array and create UIs as you go.")
	
	space(10)
	text("Scores:")
	for idx in len(scores):
		var score = scores[idx]
		text("    #%s: %s" % [idx, score])
	
	space(10)
	text("As the UI was generated from data, you can just modify the data and")
	text("the UI will update accordingly.")
	if button("Add score"):
		scores.append(0)

	space(10)
	text("You can add widgets that modify data directly. Additionally you can")
	text("add some hints to layout the data. In this case we tell the UI to")
	text("show the widgets one in front of the other with the `same_line` hint.")
	for idx in len(scores):	
		if button("+"):
			scores[idx] += 1
		same_line()
		if button("-"):
			scores[idx] -= 1
		
		var score = scores[idx]
		same_line()
		text("#%s: %s" % [idx, score])
		
	# TODO: Possible optimization: if we detect that the drawn UI is the same
	# as the previous frame, we could skip sending the draw commands to the
	# GPU.
	# end()
