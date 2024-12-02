extends TextureRect

func _set_visibility_by_selected_char():
	set_visibility_layer_bit(0, Global.char_selected_id != null)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_visibility_layer_bit(0, false)
	Global.char_selected_changed.connect(_set_visibility_by_selected_char)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
