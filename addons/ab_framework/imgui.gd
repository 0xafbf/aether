extends Control
tool
class_name ImGui

var mouse: Vector2
var draw_cursor: Vector2
var sameline_cursor: Vector2
var nextline_cursor: Vector2
var sameline: bool

# this flag should be set to false by the user
# we set it to true so he can check if any of the 
# drawn UI has resulted in changed data

var dirty: bool = false setget set_dirty, get_dirty
func set_dirty(in_dirty: bool):
	dirty = in_dirty
func get_dirty():
	return dirty

onready var button_normal = theme.get_stylebox("normal", "Button")
onready var button_hover = theme.get_stylebox("hover", "Button")
onready var button_pressed = theme.get_stylebox("pressed", "Button")

onready var input_normal = theme.get_stylebox("normal", "LineEdit")
onready var input_focus = theme.get_stylebox("focus", "LineEdit")
var input_width = 200


onready var style_window = theme.get_stylebox("panel", "WindowDialog")
onready var font = get_font("")

var delta_time: float = 0

var draw_list = []
var mouse_buttons: int
enum {
	Draw_Type_Stylebox,
	Draw_Type_Text,
	Draw_Type_Line,
}
var prev_buttons: int

func mouse_pressed(idx: int):
	return 1<<idx & mouse_buttons & ~prev_buttons
func mouse_released(idx: int):
	return 1<<idx & prev_buttons & ~mouse_buttons

var state = true
func _ready():
	lists = {}
	
var input_right: bool
var input_left: bool
var input_backspace: bool
var input_delete: bool
var input_enter: bool
var input_escape: bool

var input_unicode: int
func _input(event):
	if event is InputEventKey:
		var key_event: InputEventKey = event
		if key_event.pressed:
			if key_event.scancode == KEY_RIGHT:
				input_right = true
			if key_event.scancode == KEY_LEFT:
				input_left = true
			if key_event.scancode == KEY_BACKSPACE:
				input_backspace = true
			if key_event.scancode == KEY_DELETE:
				input_delete = true
			if key_event.scancode == KEY_ENTER:
				input_enter = true
			if key_event.scancode == KEY_ESCAPE:
				input_escape = true
				
			input_unicode = key_event.unicode

func _process(delta):
	
	mouse_default_cursor_shape = CURSOR_ARROW
	
	delta_time = delta
	mouse = get_viewport().get_mouse_position()
	prev_buttons = mouse_buttons
	mouse_buttons = Input.get_mouse_button_mask()
	

	update()

func reset_draw_lists():
	input_right = false
	input_left = false
	input_backspace = false
	input_delete = false
	input_escape = false
	input_enter = false
		
	
	input_unicode = 0
	for list_idx in lists:
		reset_window(lists[list_idx])
	
var lists: Dictionary = {}

var current_window: Dictionary
var current_window_name: String
var window_start_position = Vector2(10,40)

func reset_window(window: Dictionary):
	window.has_draw_data = false
	window.draw_list.clear()
	window.draw_cursor = Vector2()

func begin(label: String):
	current_window_name = label
	if label in lists:
		current_window = lists[label]
		draw_list = current_window.draw_list
		draw_cursor = current_window.draw_cursor
	else:
		draw_list = []
		
		draw_cursor = Vector2(
			style_window.content_margin_left, 
			style_window.content_margin_top 
			
		)	
		current_window = {
			"name": label,
			"position": window_start_position,
			"draw_list": draw_list,
			"draw_cursor": draw_cursor,
			"width": 0,
			"max_x": 0,
			"height": 0,
		}
		lists[label] = current_window
	current_window.has_draw_data = true

func end():
	var window = current_window
	window.height = draw_cursor.y
	window.draw_cursor = draw_cursor
	
func same_line(pos_x: int = -1):
	sameline = true
	nextline_cursor = draw_cursor
	draw_cursor = sameline_cursor
	if pos_x != -1:
		draw_cursor.x = pos_x

func button(label: String) -> bool:
	
	var string_size = font.get_string_size(label)
	var top_left_pad = Vector2(button_normal.content_margin_left, button_normal.content_margin_top)
	var bot_right_pad = Vector2(button_normal.content_margin_right, button_normal.content_margin_bottom)
	
	var button_size = string_size + top_left_pad + bot_right_pad
	var button_position = draw_cursor + current_window.position
	var rect = Rect2(button_position, button_size)
	var text_position = button_position + top_left_pad
	var mouse_local = mouse - rect_global_position
	var inside = rect.has_point(mouse_local)	
	
	var pressed = false
	
	var button_color = button_normal
	if inside:
		button_color = button_hover

		pressed = mouse_released(0)
		# if holding:
		if 1 & mouse_buttons:
			button_color = button_pressed
	
	draw_list.append([Draw_Type_Stylebox, button_color, rect])	
	draw_list.append([Draw_Type_Text, text_position, label])
	
	move_cursor(button_size.y + theme.get_constant("line_separation", "ItemList"), button_size.x + 4)
	dirty = dirty or pressed
	return pressed

func move_cursor(downward: int, sideways: int):
	if sameline:
		sameline = false
		draw_cursor = nextline_cursor
	else:
		sameline_cursor = draw_cursor
		draw_cursor.y += downward
		
	sameline_cursor.x += sideways
	current_window.max_x = max(current_window.max_x, sameline_cursor.x)
	
func text(in_string: String):
	draw_list.append([Draw_Type_Text, draw_cursor + current_window.position, in_string])
	var string_size = font.get_string_size(in_string)
	move_cursor(string_size.y + theme.get_constant("line_separation", "ItemList"), string_size.x)


var focus_path: String
var input_text_before_modify: String
var input_text_cursor: int
var input_text_caret_time: float

func input_text(id:String, label: String) -> String:
	var return_string = label
	var my_focus_path = PoolStringArray([current_window.name, id]).join("/")
	
	var focused = focus_path == my_focus_path
	
	var string_size = font.get_string_size(label)
	var top_left_pad = Vector2(button_normal.content_margin_left, button_normal.content_margin_top)
	var bot_right_pad = Vector2(button_normal.content_margin_right, button_normal.content_margin_bottom)
	
	var button_size = Vector2(input_width, string_size.y) + top_left_pad + bot_right_pad
	var button_position = draw_cursor + current_window.position
	var rect = Rect2(button_position, button_size)
	var text_position = button_position + top_left_pad
	var mouse_local = mouse - rect_global_position
	var inside = rect.has_point(mouse_local)
	var pressed = false
	
	var button_color = input_normal
	if focused:
		button_color = input_focus
		input_text_caret_time += delta_time
		if input_text_caret_time > 1:
			input_text_caret_time = 0
		if input_right:
			input_text_caret_time = 0
			input_text_cursor += 1
		if input_left:
			input_text_caret_time = 0
			input_text_cursor -= 1
		input_text_cursor = clamp(input_text_cursor, 0, len(label))
		
		if input_backspace:
			if input_text_cursor > 0:
				
				input_text_caret_time = 0
				return_string.erase(input_text_cursor -1 , 1)
				dirty = true
				
		if input_delete:
			if input_text_cursor < len(label):
				
				input_text_caret_time = 0
				return_string.erase(input_text_cursor, 1)
				dirty = true
		if input_unicode != 0:
			return_string = return_string.substr(0, input_text_cursor) + char(input_unicode) + return_string.substr(input_text_cursor, -1)
			input_text_cursor += 1
			
			input_text_caret_time = 0
			dirty = true
		if input_enter:
			focus_path = ""
			dirty = true
		if input_escape:
			focus_path = ""
			return_string = input_text_before_modify
			dirty = true
			
			
		
		
	if inside:
		mouse_default_cursor_shape = CURSOR_IBEAM
		pressed = mouse_released(0)
		if pressed:
			if not focused:
				input_text_before_modify = label
			focus_path = my_focus_path
			input_text_caret_time = 0
			
			var x_from_string_start = mouse_local.x - text_position.x
			var count_from_start = 0
			var pos_from_start: float = 0
			while count_from_start < len(label) and pos_from_start < x_from_string_start:
				var s = label[count_from_start]
				var c: int = ord(s)
				var char_width = font.get_char_size(c)
				pos_from_start += char_width.x
				count_from_start += 1
			input_text_cursor = count_from_start
	
	draw_list.append([Draw_Type_Stylebox, button_color, rect])	
	if focused and input_text_caret_time < 0.5:
		var substring = label.substr(0, input_text_cursor)
		var size = font.get_string_size(substring)
		var start = text_position + Vector2(size.x, 0)
		var end = text_position + Vector2(size.x, font.get_ascent())
		draw_list.append([Draw_Type_Line, start, end, Color.white])	
		
	draw_list.append([Draw_Type_Text, text_position, label])
	
	move_cursor(button_size.y + theme.get_constant("line_separation", "ItemList"), button_size.x + 4)
	return return_string
	
	



func _draw():
	var ascent = 12
	if font == null:
		font = get_font("")
	if font:
		font.get_ascent()
	for list_id in lists:
		var list = lists[list_id]
		if not list.has_draw_data:
			continue
		var width = list.width
		if width == 0:
			width = list.max_x
		var size = Vector2(width, list.height)
		draw_style_box(style_window, Rect2(list.position ,size))
		var top_left_pad = Vector2(button_normal.content_margin_left, button_normal.content_margin_top)
		var title_pos = list.position + top_left_pad
		title_pos.y += ascent - theme.get_constant("title_height", "WindowDialog")
		draw_string(font, title_pos, list_id)
		for cmd in list.draw_list:
			# draw_rect(Rect2(0,0,100,40), Color.white)
			var type = cmd[0]
			if type == Draw_Type_Stylebox:
				draw_style_box(cmd[1], cmd[2])
			elif type == Draw_Type_Text:
				var position = cmd[1]
				position.y += ascent
				draw_string(font, position, cmd[2])
			elif type == Draw_Type_Line:
				var start = cmd[1]
				var end = cmd[2]
				var color = cmd[3]
				draw_line(start, end, color)
	reset_draw_lists()

