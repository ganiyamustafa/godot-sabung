extends RichTextLabel

func _get_char_selected_node() -> Node:
	if Global.char_selected_id:
		return instance_from_id(Global.char_selected_id)
		
	return null

func _set_text_label() -> void:
	var char_selected_node = _get_char_selected_node()
	var btn_label = "Freeze"
	
	if char_selected_node and char_selected_node.is_freeze and char_selected_node.is_in_shop:
		btn_label = "Unfreeze"
		
	text = "[valign px=-3][font_size=35][b]" + btn_label + "[/b][/font_size][/valign]"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.char_selected_changed.connect(_set_text_label)
