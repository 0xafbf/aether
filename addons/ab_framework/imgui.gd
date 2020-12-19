extends Control
tool
class_name ImGui

var mouse: Vector2
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

var button_normal: StyleBox
var button_hover: StyleBox
var button_pressed: StyleBox
var label_text_color: Color
var button_text_color: Color
var button_text_color_pressed: Color

var input_normal: StyleBox
var input_focus: StyleBox

var style_window: StyleBox

var checkbox_unchecked: Texture
var checkbox_checked: Texture

var input_width = 200
var font: Font
var ascent: float
var font_height: float

var dummy = refresh_styles()
onready var dummy2 = refresh_styles()

func refresh_styles():
	label_text_color = get_color("font_color", "Label")
	button_text_color = get_color("font_color", "Button")
	button_text_color_pressed = get_color("font_color_pressed", "CheckButton")
	
	button_normal = get_stylebox("normal", "Button")
	button_hover = get_stylebox("hover", "Button")
	button_pressed = get_stylebox("pressed", "Button")

	input_normal = get_stylebox("normal", "LineEdit")
	input_focus = get_stylebox("focus", "LineEdit")

	style_window = get_stylebox("panel", "WindowDialog")
	font = get_font("")
	ascent = font.get_ascent()
	font_height = font.get_height()
	
	checkbox_unchecked = get_icon("unchecked", "CheckBox")
	checkbox_checked   = get_icon("checked", "CheckBox")

var delta_time: float = 0

var mouse_buttons: int
enum {
	Draw_Type_Stylebox,
	Draw_Type_Text,
	Draw_Type_Line,
	Draw_Type_Texture,
}
var prev_buttons: int

func mouse_pressed(idx: int):
	return 1<<idx & mouse_buttons & ~prev_buttons
func mouse_released(idx: int):
	return 1<<idx & prev_buttons & ~mouse_buttons

var state = true
	
var input_right: bool
var input_left: bool
var input_backspace: bool
var input_delete: bool
var input_enter: bool
var input_escape: bool

var input_unicode: int
func _input(event):
	if event is InputEventKey and has_focus():
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
			get_tree().set_input_as_handled()
			
func _enter_tree():
	focus_mode = Control.FOCUS_ALL
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
	reset_window()
	
var window_start_position = Vector2(10,40)

func reset_window():
	has_draw_data = false
	draw_list.clear()
	draw_cursor = Vector2()

var width: int
var draw_list: Array
var draw_cursor: Vector2
var has_draw_data: bool = false
var position: Vector2

func begin() -> void:
	refresh_styles()
	if not has_draw_data:
		has_draw_data = true
		var w = style_window
		draw_cursor = Vector2(w.content_margin_left, w.content_margin_top)
	
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
	var button_position = draw_cursor + position
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
	queue_text(label, text_position, button_text_color)
	
	
	var separation_y = get_constant("line_separation", "ItemList")
	move_cursor(button_size.y + separation_y, button_size.x + 4)
	dirty = dirty or pressed
	
	return pressed

func tabs(enums: Dictionary, base: int) -> int:
	for key in enums:
		var selected = base == enums[key]
		pass
	return 0

func toggle(label: String, previous: bool) -> bool:
	var string_size = font.get_string_size(label)
	var top_left_pad = Vector2(button_normal.content_margin_left, button_normal.content_margin_top)
	var bot_right_pad = Vector2(button_normal.content_margin_right, button_normal.content_margin_bottom)
	
	var button_size = string_size + top_left_pad + bot_right_pad
	var button_position = draw_cursor + position
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
	var color = button_text_color_pressed if previous else button_text_color
	queue_text(label, text_position, color)
	
	
	var separation_y = get_constant("line_separation", "ItemList")
	move_cursor(button_size.y + separation_y, button_size.x + 4)
	dirty = dirty or pressed
	
	if pressed:
		return !previous
	return previous


func checkbox(label: String, previous: bool) -> bool:
	var string_size = font.get_string_size(label)
	var top_left_pad = Vector2(button_normal.content_margin_left, button_normal.content_margin_top)
	var bot_right_pad = Vector2(button_normal.content_margin_right, button_normal.content_margin_bottom)
	
	
	var check_texture: Texture = checkbox_checked if previous else checkbox_unchecked
	var check_size: Vector2 = check_texture.get_size()
	
	var button_size = string_size + top_left_pad + bot_right_pad
	button_size.x += check_size.x
	
	var button_position = draw_cursor + position
	var rect = Rect2(button_position, button_size)
	
	
	var text_position = button_position + top_left_pad
	text_position.x += check_size.x
	
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
	
	var new: bool = previous
	if pressed:
		new = !previous
	
	var checkbox_position = button_position
	var delta = (font_height - check_size.y) * 0.5 + top_left_pad.y
	checkbox_position.y += delta 
	_queue_texture(check_texture, checkbox_position)
	
	var color = button_text_color_pressed if new else button_text_color
	queue_text(label, text_position, color)
	
	
	var separation_y = get_constant("line_separation", "ItemList")
	move_cursor(button_size.y + separation_y, button_size.x + 4)
	dirty = dirty or pressed
	
	return new	

func move_cursor(downward: int, sideways: int):
	if sameline:
		sameline = false
		draw_cursor = nextline_cursor
	else:
		sameline_cursor = draw_cursor
		draw_cursor.y += downward
		
	sameline_cursor.x += sideways
	# current_window.max_x = max(current_window.max_x, sameline_cursor.x)
	
func text(in_string: String):
	queue_text(in_string, draw_cursor+position, label_text_color)
	var string_size = font.get_string_size(in_string)
	var separation_y = get_constant("line_separation", "ItemList")
	move_cursor(string_size.y + separation_y, string_size.x)

func queue_text(in_string: String, in_position: Vector2, in_color: Color):
	draw_list.append([Draw_Type_Text, in_position, in_string, in_color])

func _queue_texture(in_texture: Texture, in_position: Vector2):
	draw_list.append([Draw_Type_Texture, in_texture, in_position])

var focus_path: String
var input_text_before_modify: String
var input_text_cursor: int
var input_text_caret_time: float

func input_text(id:String, in_string: String) -> String:
	var return_string = in_string
	# @FocusPath
	var my_focus_path = PoolStringArray(["", id]).join("/")
	
	var focused = focus_path == my_focus_path
	
	var string_size = font.get_string_size(in_string)
	var top_left_pad = Vector2(button_normal.content_margin_left, button_normal.content_margin_top)
	var bot_right_pad = Vector2(button_normal.content_margin_right, button_normal.content_margin_bottom)
	
	var button_size = Vector2(input_width, string_size.y) + top_left_pad + bot_right_pad
	var button_position = draw_cursor + position
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
		input_text_cursor = clamp(input_text_cursor, 0, len(in_string))
		
		if input_backspace:
			if input_text_cursor > 0:
				
				input_text_caret_time = 0
				return_string.erase(input_text_cursor -1 , 1)
				dirty = true
				
		if input_delete:
			if input_text_cursor < len(in_string):
				
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
			release_focus()
		if input_escape:
			focus_path = ""
			return_string = input_text_before_modify
			dirty = true
			release_focus()
			
		
		
	if inside:
		mouse_default_cursor_shape = CURSOR_IBEAM
		pressed = mouse_released(0)
		if pressed:
			if not focused:
				input_text_before_modify = in_string
				grab_focus()
			focus_path = my_focus_path
			input_text_caret_time = 0
			
			var x_from_string_start = mouse_local.x - text_position.x
			var count_from_start = 0
			var pos_from_start: float = 0
			while count_from_start < len(in_string) and pos_from_start < x_from_string_start:
				var s = in_string[count_from_start]
				var c: int = ord(s)
				var char_width = font.get_char_size(c)
				pos_from_start += char_width.x
				count_from_start += 1
			input_text_cursor = count_from_start
	
	draw_list.append([Draw_Type_Stylebox, button_color, rect])	
	if focused and input_text_caret_time < 0.5:
		var substring = in_string.substr(0, input_text_cursor)
		var size = font.get_string_size(substring)
		var start = text_position + Vector2(size.x, 0)
		var end = text_position + Vector2(size.x, ascent)
		draw_list.append([Draw_Type_Line, start, end, Color.white])	
		
	queue_text(in_string, text_position, label_text_color)
	
	move_cursor(button_size.y + get_constant("line_separation", "ItemList"), button_size.x + 4)
	return return_string
	

func _draw():
	if has_draw_data:	
		for cmd in draw_list:
			# draw_rect(Rect2(0,0,100,40), Color.white)
			var type = cmd[0]
			if type == Draw_Type_Stylebox:
				draw_style_box(cmd[1], cmd[2])
			elif type == Draw_Type_Text:
				var position = cmd[1]
				position.y += ascent
				draw_string(font, position, cmd[2], cmd[3])
			elif type == Draw_Type_Line:
				var start = cmd[1]
				var end = cmd[2]
				var color = cmd[3]
				draw_line(start, end, color)
			elif type == Draw_Type_Texture:
				var texture: Texture = cmd[1]
				var position: Vector2 = cmd[2]
				draw_texture(texture, position)
				
	reset_draw_lists()

