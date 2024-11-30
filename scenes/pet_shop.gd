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
		child.queue_free()
	
func _create_char_shop_node(pos_x: int, pos_y: int, width: int = 130, height: int = 100) -> Control:
	var char_nodes = get_node("../../TmpControl/ShopBundle/Tier1").get_children()
	var char_shop_control: Control = RandomUtils.choice(char_nodes).duplicate()
	char_shop_control.set_position(Vector2(pos_x, pos_y))
	
	return char_shop_control
	
func add_pet_tile_node_on_ready() -> void:
#	remove all children so not stacked when regenerate
	_remove_children()
	
	var pet_tile_w = 130
	var pet_tile_h = 100
	var pet_tile_pos_x = 24
	var pet_tile_pos_y = -50
	var spacing = 20
	
	for x in range(1, 4):
#		init node position
		var pet_tile_pos = pet_tile_pos_x + (pet_tile_w + spacing) * x
		
#		add node as a child
		add_child(_create_char_shop_node(
			pet_tile_pos, pet_tile_pos_y, 
			pet_tile_w, pet_tile_h))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_pet_tile_node_on_ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
