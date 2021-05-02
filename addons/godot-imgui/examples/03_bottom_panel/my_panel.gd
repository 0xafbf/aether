# godot-imgui 2021 by Andrés Botero
# my_extension_editor
# shows how to create an editor panel by simply overriding a function.
# you receive the EditorInterface object, so you can ask for almost anything.
# This works by checking if any scripts inherits from ImGuiEditor on save,
# that means it won't load at start, but only when saved after modifying it.
# If you know a way to make it load automatically, let me know.

extends ImGuiEditor

# it needs to be a tool to work
tool

# this is an ImGui object, so you can do direct calls to imgui
func imgui_editor(editor: EditorInterface):
	begin()
	text("== My Custom Panel ==")
	if button("print in console"):
		print("you clicked!")
	text("Notes:")
	text("* TODO: write a nice use case here")
	text("* TODO: Find a way to tell Godot the panel height")
	text("* TODO: Find a way to set the label in the bottom bar")
	text("* Maybe can be used with a side dock instead?")
	text("- Doesn't let see console at the same time")
	text("+ works nice for editing code and seeing result by saving")
	
