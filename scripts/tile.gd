extends Control


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data.is_in_group("char") and is_in_group("empty_space")

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var dragged_original_node = instance_from_id(Global.char_dragged_id)
	
#	remove ice freeze from node
	if data.is_in_group("freeze"):
		data.remove_child(data.get_node("IceFreeze"))
		
#	remove before space to empty
	if not dragged_original_node.is_in_group("shop"):
		dragged_original_node.get_parent().add_to_group("empty_space")
	
#	remove char from group
	data.remove_from_group("freeze")
	data.remove_from_group("shop")
	
#	delete original node
	dragged_original_node.queue_free()
	Global.char_dragged_id = null
	
#	remove from empty space group
	remove_from_group("empty_space")
	
#	add node to tile
	add_child(data)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
