extends TextureButton

func _get_char_selected_node() -> Node:
	if Global.char_selected_id:
		return instance_from_id(Global.char_selected_id)
		
	return null

func _set_visibility() -> void:
	set_visibility_layer_bit(0, Global.char_selected_id != null)

func _get_ice_node() -> Node:
	return get_tree().get_nodes_in_group("UI")[1].duplicate()

func _add_ice_node_as_char_shop_child(char_node: Node) -> void:
	var ice_node = _get_ice_node()
	ice_node.set_position(Vector2(-40, -5))
	char_node.add_child(ice_node)
	
func _remove_ice_node_from_char_shop_child(char_node: Node) -> void:
	var ice_node = char_node.get_node("./IceFreeze")
	char_node.remove_child(ice_node)

func _freeze_char_shop(char_node: Node) -> void:
	if char_node.is_in_shop and not char_node.is_freeze:
		char_node.is_freeze = true
		_add_ice_node_as_char_shop_child(char_node)
	
func _unfreeze_char_shop(char_node: Node) -> void:
	if char_node.is_in_shop and char_node.is_freeze:
		char_node.is_freeze = false
		_remove_ice_node_from_char_shop_child(char_node)

func _pressed() -> void:
	var char_selected_node = _get_char_selected_node()
	
	if char_selected_node:
		if not char_selected_node.is_freeze:
			_freeze_char_shop(char_selected_node)
		else:
			_unfreeze_char_shop(char_selected_node)
		
#		reset selected char
		Global.char_selected_id = null
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_visibility_layer_bit(0, false)
	Global.char_selected_changed.connect(_set_visibility)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
