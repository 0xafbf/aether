tool
extends ImGui
var editor_interface: EditorInterface

func _enter_tree():
	print("enter tree")

func _ready():
	print("ready")
	._ready()

var edited_obj: Resource
func _process(delta):
	
	._process(delta)
	if edited_obj:
		begin(edited_obj.resource_name)
		self.set_dirty(false)
		edited_obj.custom_editor(self)
		end()
	
	begin("ventana 2")
	text("hola")
	end()
			
func edit(obj):
	edited_obj = obj
