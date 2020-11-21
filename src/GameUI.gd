extends Control

# export(Array, NodePath) var slots

onready var slots_nodes = {
	BrushMode.BRUSH_OFF: $ColorRect2/HBoxContainer/IconToolNone,
	BrushMode.BRUSH_BUILD: $ColorRect2/HBoxContainer/IconToolAdd,
	BrushMode.BRUSH_DESTROY: $ColorRect2/HBoxContainer/IconToolDelete,
	BrushMode.BRUSH_EDIT: $ColorRect2/HBoxContainer/IconToolEdit,
	BrushMode.BRUSH_PAINT: $ColorRect2/HBoxContainer/IconToolPaint,
}
var character

func _ready():
	for node_id in slots_nodes:
		var node = slots_nodes[node_id]
		assert(node is TextureRect)
		node.self_modulate = inactive_color

export var active_color: Color
export var inactive_color: Color

var active_slot: TextureRect
func set_brush_mode(new_mode):
	if active_slot:
		active_slot.self_modulate = inactive_color

	for node_id in slots_nodes:
		
		if node_id == new_mode:
			var node = slots_nodes[node_id]
			active_slot = node
			active_slot.self_modulate = active_color
	
	$PaintInfo.visible = (new_mode == BrushMode.BRUSH_PAINT)
		
			
			
func set_paint_id(paint_id):
	if $PaintInfo.visible:
		$PaintInfo/Label.text = "Color ID:%s" % paint_id
