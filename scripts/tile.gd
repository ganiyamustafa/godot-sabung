extends Control

func drop_char_data(at_position: Vector2, data: Variant) -> void:
	var dragged_original_node = instance_from_id(Global.char_dragged_id)
	var dragged_char_node = dragged_original_node.get_parent()
	
#	remove ice freeze from node
	if dragged_char_node.is_in_group("freeze"):
		dragged_char_node.remove_child(dragged_char_node.get_node("./IceFreeze"))
	
#	remove before space to empty
	if not dragged_char_node.is_in_group("shop"):
		dragged_char_node.get_parent().add_to_group("empty_space")
	
#	remove char from group
	data.remove_from_group("freeze")
	data.remove_from_group("shop")
	
#	delete original node
	for child in dragged_char_node.get_children():
		if child.name != "Tile":
			child.queue_free()

	Global.char_dragged_id = null
	
#	remove from empty space group
	remove_from_group("empty_space")
	
	data.set_position(Vector2(9, 0))
	
#	add node to tile
	add_child(data)
	
	#	buy emit
	if dragged_char_node.is_in_group("shop"):
		Global.buy.emit(data.get_instance_id())

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return (data.is_in_group("char") and is_in_group("empty_space")) or (
		data.is_in_group("shop") and Global.coin >= data.price and get_node("./Char"))

func _drop_data(at_position: Vector2, data: Variant) -> void:
	drop_char_data(at_position, data)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
