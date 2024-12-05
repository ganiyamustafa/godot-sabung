extends TextureButton

class_name CharDragNDrop

var original_texture_normal = null

func _get_select_hover_node() -> TextureRect:
	return get_tree().get_nodes_in_group("UI")[0]
	
func _set_global_position_select_node(node: Node) -> void:
	node.z_index = 1
	node.set_global_position(
		Vector2(global_position.x - 100, global_position.y)
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
	Global.buy.connect(_on_buy)
	
func _get_drag_data(at_position: Vector2) -> Variant:
	var preview_node = get_parent().duplicate()
	if preview_node.is_in_group("freeze"):
		preview_node.remove_child(preview_node.get_node("./IceFreeze"))

	preview_node.get_node("./Tile").visible = false
	
#	change texture to null
	original_texture_normal = texture_normal
	texture_normal = null
	
#	set selected char
	Global.char_dragged_id = get_instance_id()

	return preview_node

func _is_coin_enough(dragged_char_node: Node, char_node: Node) -> bool:
	if dragged_char_node.is_in_group("shop"):
		return Global.coin >= dragged_char_node.price
	
	return true

func _is_can_level_up(dragged_char_node: Node, char_node: Node) -> bool:
	if char_node.id == dragged_char_node.id:
		return char_node.level < 3 or not (dragged_char_node.is_in_group("shop") and char_node.level >= 3)
	
	return true

func _is_empty_space_available(dragged_char_node: Node, char_node: Node) -> bool:
	var empty_spaces = get_tree().get_nodes_in_group("empty_space")
	return empty_spaces or dragged_char_node.id == char_node.id or not dragged_char_node.is_in_group("shop")

func _is_char_or_item(dragged_char_node: Node) -> bool:
	return dragged_char_node.is_in_group("char") or dragged_char_node.is_in_group("item")
	

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	var dragable_original_node = instance_from_id(Global.char_dragged_id)
	var dragged_char_node = dragable_original_node.get_parent()
	var empty_spaces = get_tree().get_nodes_in_group("empty_space").slice(1)
	var char_node = get_parent()
	
	return (
		not char_node.is_in_group("shop") and char_node.get_instance_id() != dragged_char_node.get_instance_id() and 
		(
			_is_coin_enough(data, char_node) and _is_char_or_item(data) and
			_is_empty_space_available(data, char_node) and _is_can_level_up(data, char_node)
		)
	)
	
func _replace_position_tile(at_position: Vector2, data: Variant) -> void:
	var dragged_original_node = instance_from_id(Global.char_dragged_id)
	var dragged_char_node = dragged_original_node.get_parent()
	var dragged_tile_node = dragged_original_node.get_parent().get_parent()
	var char_node = get_parent()
	var tile_node = char_node.get_parent()
	
#	add char to parent of dragable original node
	dragged_tile_node.add_child(get_parent().duplicate())
	
#	remove original node
	dragged_char_node.queue_free()
	char_node.queue_free()
	
#	add dragable node to parent
	tile_node.add_child(data)


func _add_exp_char(char_node: Node, dragged_char_node: Node) -> void:
	var char_node_id = char_node.get_instance_id()
	var char_level = [char_node.level, dragged_char_node.level].max()
	
	char_node.exp += dragged_char_node.exp
	Global.exp_added.emit(char_node_id)
	
	if ((char_node.level != dragged_char_node.level and dragged_char_node.level > 1) or (char_node.level > 1 and dragged_char_node.level > 1)) and not dragged_char_node.is_in_group("shop"):
		char_node.exp += Global.level_up_exp_need[char_level-1]


func _level_up_char(char_node: Node, dragged_char_node: Node) -> void:
	var char_node_id = char_node.get_instance_id()
	
	if char_node.exp >= Global.level_up_exp_need[char_node.level-1]:
		if char_node.level < 2:
			char_node.exp = abs(Global.level_up_exp_need[char_node.level-1] - char_node.exp + 1)
			
		char_node.level += 1
		Global.level_up_bar.emit(char_node_id)
		
		if char_node.level >= dragged_char_node.level:
			Global.level_up.emit(char_node_id)
			
		if len(Global.level_up_exp_need) >= char_node.level and char_node.exp >= Global.level_up_exp_need[char_node.level-1]:
			_fusion_char(Vector2(0, 0), dragged_char_node)

func _fusion_char(at_position: Vector2, data: Variant) -> void:
	var dragged_original_node = instance_from_id(Global.char_dragged_id)
	var dragged_char_node = dragged_original_node.get_parent()
	var char_node = get_parent()
	var char_node_id = char_node.get_instance_id()
	var dragged_tile_node = dragged_char_node.get_parent()
	var char_level = [char_node.level, dragged_char_node.level].max()
	
	if char_level >= 3:
		return _replace_position_tile(at_position, data)
	
#	add exp char
	_add_exp_char(char_node, dragged_char_node)
	
#	add char tile to empty space
	if not dragged_char_node.is_in_group("shop"):
		dragged_tile_node.add_to_group("empty_space")
	
#	delete dragged original node
	for child in dragged_char_node.get_children():
		if child.name != "Tile" or not dragged_char_node.is_in_group("shop"):
			child.queue_free()
			
#	level up char
	_level_up_char(char_node, dragged_char_node)
		
#	emit buy signal
	if dragged_char_node.is_in_group("shop"):
		Global.buy.emit(char_node.get_instance_id())
	
	return

func _add_char_to_empty_space(at_position: Vector2, data: Variant) -> void:
	var empty_spaces = get_tree().get_nodes_in_group("empty_space")
	if empty_spaces:
		var empty_space = RandomUtils.choice(empty_spaces)
		empty_space.drop_char_data(at_position, data)
		return

func _drop_char_data(at_position: Vector2, data: Variant) -> void:
	var dragged_original_node = instance_from_id(Global.char_dragged_id)
	var dragged_char_node = dragged_original_node.get_parent()
	var char_node = get_parent()
	
	if dragged_char_node.id == char_node.id:
		return _fusion_char(at_position, data)
		
	if not (data.is_in_group("shop") or char_node.is_in_group("shop")):
		return _replace_position_tile(at_position, data)
		
	if data.is_in_group("shop"):
		return _add_char_to_empty_space(at_position, data)

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
		
func _reduce_coin_on_buy(char_node: Node) -> void:
	Global.coin -= char_node.price

func _on_buy(emitted_instance_id: int) -> void:
	var char_node = get_parent()
	
	if char_node.get_instance_id() == emitted_instance_id:
		_reduce_coin_on_buy(char_node)
