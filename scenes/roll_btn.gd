extends TextureButton

func _get_pet_shop_node() -> Control:
	var pet_shop_node = get_node("../PetShop")
	return pet_shop_node
	
func _refresh_shop() -> void:
	if Global.coin > 0:
		_get_pet_shop_node().add_pet_tile_node_on_ready()
		Global.coin -= 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _pressed() -> void:
	_refresh_shop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
