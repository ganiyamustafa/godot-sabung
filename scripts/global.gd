extends Node

var coin = 50
var live = 10
var char_shop_count = 3
var is_dragging = false
var current_tier_shop = 1
var shop_price = 3
var level_up_exp_need = [3, 4]

var char_dragged_id = null

# roll shop signal
signal shop_rolled

# exp add signal
signal exp_added

# buy signal
signal buy

# level up signal
signal level_up

# level up bar signal
signal level_up_bar

# char selected on pressed
signal char_selected_changed
var char_selected_id = null: set = _set_char_selected_id

func _set_char_selected_id(value) -> void:
	if char_selected_id != value:
		char_selected_id = value
		emit_signal("char_selected_changed")
