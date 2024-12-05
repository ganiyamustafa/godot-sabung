extends Control

#func _create_pet_tile_node(pos_x: int, pos_y: int, width: int = 130, height: int = 100) -> TextureRect:
	#var pet_tile_texture = load("res://src/tile-1.png")
	#var pet_tile_node = TextureRect.new()
	#
##	set pet tile attribute
	#pet_tile_node.texture = pet_tile_texture
	#pet_tile_node.stretch_mode = TextureRect.STRETCH_SCALE
	#pet_tile_node.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	#pet_tile_node.set_size(Vector2(width, height))
	#pet_tile_node.set_position(Vector2(pos_x, pos_y))
	#
	#return pet_tile_node
	
func _remove_children() -> void:
	for child in get_children():
#		only remove not freezed char
		if not child.is_in_group("freeze"):
			child.queue_free()

func _get_char_shop_filter(data: Node) -> bool:
	return data.is_in_group("helper") and data.is_in_group("char")
	
func _get_item_shop_filter(data: Node) -> bool:
	return data.is_in_group("helper") and data.is_in_group("item")

func _get_shop_datas_by_minimum_tier(tier: int = 1) -> Array:
	var shop_char_datas: Array[Node] = []
	var shop_item_datas: Array[Node] = []
	var tree = get_tree()
	
	for current_tier in range(1, tier + 1):
		var tier_group = "tier" + str(current_tier)
		
#		get char shop datas
		shop_char_datas += tree.get_nodes_in_group(tier_group).filter(_get_char_shop_filter)
		
#		get item shop datas
		shop_item_datas += tree.get_nodes_in_group(tier_group).filter(_get_item_shop_filter)
	
	return [shop_char_datas, shop_item_datas]
	
func _create_char_shop_node(char_nodes: Array[Node], pos_x: int, pos_y: int, width: int = 130, height: int = 100) -> Node:
#	create new random char node
	var char_shop_control = RandomUtils.choice(char_nodes).duplicate()
	char_shop_control.remove_from_group("helper")
	
#	set char node position		
	char_shop_control.set_position(Vector2(pos_x, pos_y))
	
	return char_shop_control
	
func _keep_freeze_char_node(char_node: Node, pos_x: int, pos_y: int, width: int = 130, height: int = 100) -> void:
	char_node.set_position(Vector2(pos_x, pos_y))
	
func _get_freeze_char_node():
	var freeze_char = []
	
	for child in get_children():
#		append child if char is freeze
		if child.is_in_group("freeze"):
			freeze_char.append(child)
			
	return freeze_char

func add_pet_tile_node_on_ready() -> void:
#	remove all children so not stacked when regenerate
	_remove_children()
	
#	get all shop tier nodes
	var shop_datas = _get_shop_datas_by_minimum_tier(Global.current_tier_shop)
	var char_nodes = shop_datas[0]
	var item_nodes = shop_datas[1]
	
	var pet_tile_w = 433
	var pet_tile_h = 333
	var pet_tile_pos_x = 24
	var pet_tile_pos_y = 60
	var spacing = 20
	
#	get all freezen char shop
	var freeze_char_nodes = _get_freeze_char_node()
	
	for x in range(1, Global.char_shop_count + 1):
#		init node position
		var pet_tile_pos = pet_tile_pos_x + (pet_tile_w + spacing) * x
		
		if freeze_char_nodes:
			_keep_freeze_char_node(
				freeze_char_nodes.pop_front(),
				pet_tile_pos, pet_tile_pos_y, 
				pet_tile_w, pet_tile_h
			)
		else:
	#		add node as a child
			add_child(_create_char_shop_node(
				char_nodes,
				pet_tile_pos, pet_tile_pos_y, 
				pet_tile_w, pet_tile_h))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.shop_rolled.connect(add_pet_tile_node_on_ready)
	add_pet_tile_node_on_ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
