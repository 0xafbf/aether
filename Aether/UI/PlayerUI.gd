extends Control


func _ready():
	# var mouse_mode = Input.get_mouse_mode()
	var mouse_mode = Input.MOUSE_MODE_VISIBLE
	set_mouse_mode(mouse_mode)

	# will load 'default' by default
	world_name = "default"
	load_world()


func set_mouse_mode(mouse_mode):
	Input.set_mouse_mode(mouse_mode)

	visible = (mouse_mode != Input.MOUSE_MODE_CAPTURED)


func _input(event):
	var key_event = event as InputEventKey
	if key_event && key_event.pressed:
		if key_event.scancode == KEY_ESCAPE:
			var current_mode = Input.get_mouse_mode()
			if current_mode == Input.MOUSE_MODE_VISIBLE:
				set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else:
				set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if key_event.scancode == KEY_F11:
			OS.window_fullscreen = !OS.window_fullscreen

# this is to capture after gui processed

func _gui_input(event):
	var mouse_event = event as InputEventMouseButton
	if mouse_event:
		print(mouse_event, mouse_event.button_index)
		if mouse_event.button_index == 1:
			set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			return

var popup: PopupMenu
func _on_MenuButton_about_to_show():

	var menu_btn: MenuButton = $VSplitContainer/MenuBarBG/MenuBar/MenuButton

	# just being safe .. ?
	var new_popup = menu_btn.get_popup()
	if popup != new_popup:
		popup = new_popup
		popup.connect("id_pressed", self, "menu_selected")


func menu_selected(id: int):
	var menu_item = popup.get_item_text(id)
	if menu_item == "New":
		clear_world()
	elif menu_item == "Load":
		load_world()
	elif menu_item == "Save":
		save_world()


func clear_world():
	print("cleared_world")
	var block_nodes = get_tree().get_nodes_in_group("Blocks")
	for node in block_nodes:
		node.queue_free()
		# TODO: load template? not if called from load_world

func get_world():
	return get_node("/root/World")

export(String, FILE, "*.tscn") var brick_template_path
onready var brick_template = load(brick_template_path)

export var world_name = "default"

func load_world():
	print("loading world")
	var save_path = "user://%s.aether" % world_name

	var save_game = File.new()
	if not save_game.file_exists(save_path):
		print("warning: loading path %s not found" % save_path)
		return

	var world = get_world()

	clear_world()

	save_game.open(save_path, File.READ)

	var json_text = save_game.get_line()

	var world_data = parse_json(json_text)
	for brick_data in world_data["blocks"]:
		var brick_object = brick_template.instance() as Brick
		brick_object.deserialize(brick_data)
		world.call_deferred("add_child", brick_object)
		print("restored:%s in world:%s"%[brick_object, world])

	save_game.close()

func save_world():
	var save_path = "user://%s.aether" % world_name
	var save_game = File.new()
	save_game.open(save_path, File.WRITE)

	var nodes_to_save = get_tree().get_nodes_in_group("Blocks")

	var block_list = []
	for node in nodes_to_save:
		var node_data = node.serialized()
		block_list.append(node_data)

	var world_data = {
		"world_name": world_name,
		"blocks": block_list
	}
	var json_data = to_json(world_data)
	save_game.store_line(json_data)


	save_game.close()


var level_list = []
func _on_LevelsMenu_about_to_show():
	level_list = []
	var saves_dir = "user://"
	var dir = Directory.new()
	dir.open(saves_dir)
	dir.list_dir_begin(true, true)
	while true:
		var file = dir.get_next()
		if not file:
			break
		if file.ends_with(".aether"):
			file = file.rsplit(".", true, 1)[0]
			level_list.append(file)


	var menu_btn = $VSplitContainer/MenuBarBG/MenuBar/LevelsMenu
	var popup = menu_btn.get_popup()
	popup.clear()
	var idx = 0
	for file in level_list:
		popup.add_item(file, idx)
		idx += 1
	popup.connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(id):
	world_name = level_list[id]

	var level_input = $VSplitContainer/MenuBarBG/MenuBar/LevelName
	level_input.text = world_name
	load_world()


func _on_LevelName_text_entered(new_text):
	var level_input = $VSplitContainer/MenuBarBG/MenuBar/LevelName
	world_name = level_input.text
	save_world()


func _on_SaveButton_pressed():
	save_world()


func _on_Exit_pressed():
	get_tree().quit()


var last_window_position = null
var last_cursor_position = null
var dragging = false
func drag_area_input(event):
	if event is InputEventMouseMotion:
		var motion = event as InputEventMouseMotion
		if dragging:
			print("evt motion:%s" % motion.relative)
			print("global position:%s" % event.global_position)
			var delta = event.global_position - last_cursor_position
			print("delta:%s" % delta)
			OS.window_position += delta
	elif event is InputEventMouseButton:
		var button = event as InputEventMouseButton
		dragging = event.pressed
		if dragging:
			last_window_position = OS.window_position
			last_cursor_position = event.global_position
		
	
