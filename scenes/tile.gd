extends Control


func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data.is_in_group("char")

func _drop_data(at_position: Vector2, data: Variant) -> void:
	data.is_in_shop = false
	Global.char_dragged_id = null
	add_child(data)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
