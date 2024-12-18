extends TextureButton

func _get_pet_shop_node() -> Control:
	var pet_shop_node = get_node("../PetShop")
	return pet_shop_node
	
func _refresh_shop() -> void:
	if Global.coin > 0:
		Global.shop_rolled.emit()
		Global.coin -= 1
		
	Global.char_selected_id = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _pressed() -> void:
	_refresh_shop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
