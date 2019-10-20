extends Control

# export(Array, NodePath) var slots
var slots_nodes = []
var character

func _ready():
	var slots = $ColorRect2/HBoxContainer.get_children()
	for node in slots:
		if node is UIBrushSlot:
			slots_nodes.append(node)
			node.self_modulate = inactive_color

export var active_color: Color
export var inactive_color: Color

var active_slot: UIBrushSlot
func set_brush_mode(new_mode):
	if active_slot:
		active_slot.self_modulate = inactive_color

	for node in slots_nodes:
		if node.brush_mode == new_mode:
			active_slot = node
			active_slot.self_modulate = active_color
	
	$PaintInfo.visible = (new_mode == Brush.BrushMode.BRUSH_PAINT)
		
			
			
func set_paint_id(paint_id):
	if $PaintInfo.visible:
		$PaintInfo/Label.text = "Color ID:%s" % paint_id