extends TextureButton

class_name CharDragNDrop

var original_texture_normal = null

func _get_select_hover_node() -> TextureRect:
	return get_tree().get_nodes_in_group("UI")[0]
	
func _set_global_position_select_node(node: Node) -> void:
	node.z_index = 1
	node.set_global_position(
		Vector2(global_position.x - 20, global_position.y)
	)
	
func _set_visibility_select_node(node: Node, visible: bool = false) -> void:
	node.set_visibility_layer_bit(0, visible)

func _on_mouse_entered() -> void:
	var select_node = _get_select_hover_node()
	_set_visibility_select_node(select_node, true)
	_set_global_position_select_node(select_node)
	
func _on_mouse_exited() -> void:
	_set_visibility_select_node(_get_select_hover_node(), false)

func _get_select_pressed_node() -> TextureRect:
	return get_tree().get_nodes_in_group("UI")[1]

func _pressed() -> void:
	var select_node = _get_select_pressed_node()
	_set_visibility_select_node(select_node, true)
	_set_global_position_select_node(select_node)
	
	Global.char_selected_id = get_instance_id()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	
func _get_drag_data(at_position: Vector2) -> Variant:
	var preview_node = duplicate()
	
#	change texture to null
	original_texture_normal = texture_normal
	texture_normal = null
	
#	set selected char
	Global.char_dragged_id = get_instance_id()

	return preview_node
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var dragable_original_node = instance_from_id(Global.char_dragged_id)
	return (data.is_in_group("char") or data.is_in_group("item")) and not is_in_group("shop") and not is_in_group("item") and get_instance_id() != dragable_original_node.get_instance_id()
	
func _replace_position_tile(at_position: Vector2, data: Variant) -> void:
	var dragged_original_node = instance_from_id(Global.char_dragged_id)
	
#	add char to parent of dragable original node
	dragged_original_node.get_parent().add_child(get_node(".").duplicate())
	
#	remove original node
	dragged_original_node.queue_free()
	queue_free()
	
#	add dragable node to parent
	get_parent().add_child(data)

func _drop_char_data(at_position: Vector2, data: Variant) -> void:
	var dragged_original_node = instance_from_id(Global.char_dragged_id)
	var this = get_node(".")
	
	print(owner)
	if data.id == this.id:
		this.level += data.level
		dragged_original_node.get_parent().add_to_group("empty_space")
		dragged_original_node.queue_free()
		return
		
	if not (data.is_in_group("shop") and is_in_group("shop")):
		_replace_position_tile(at_position, data)

func _drop_item_data(at_position: Vector2, data: Variant) -> void:
	pass

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data.is_in_group("char"):
		return _drop_char_data(at_position, data)
	
	if data.is_in_group("item"):
		return _drop_item_data(at_position, data)
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END and not is_drag_successful() and get_instance_id() == Global.char_dragged_id:
		texture_normal = original_texture_normal
		Global.char_dragged_id = null
		
	
