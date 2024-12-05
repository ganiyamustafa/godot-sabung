extends Control

func _set_exp_bar_position(bar_index: int, bar_node: Node) -> void:
	var bar_w = bar_node.size.x
	var pos_x = 61
	var pos_y = 51
	
	pos_x = pos_x + (bar_w) * (bar_index)
	
	bar_node.set_position(Vector2(pos_x, pos_y))

func _set_exp_bar_size(total_bar: int, bar_node: Node, total_w: int) -> void:
	bar_node.set_size(Vector2(total_w / total_bar, 87))

func _add_exp_bar(emitted_instance_id: int = 0) -> void:
	visible = true
	var char_node = get_parent()
	
#	set visible to false if char is in shop
	if char_node.is_in_group("shop"):
		visible = false
	
	if emitted_instance_id == 0 or (emitted_instance_id == char_node.get_instance_id() and char_node.level < 3):		
		var total_w = 320
		var char_level = [2, char_node.level].min()

		#	remove children
		_remove_children()
	
		var total_bar = Global.level_up_exp_need[char_level-1]-1
		
		for bar_index in range(0, total_bar):
			var bar_node = get_node("Bar").duplicate()
			bar_node.visible = true
			bar_node.add_to_group("empty_exp_bar")
			
			_set_exp_bar_size(total_bar, bar_node, total_w)
			_set_exp_bar_position(bar_index, bar_node)	
			
			add_child(bar_node)
		
	_fill_level_bar(char_node.get_instance_id())
			
func _fill_level_bar(emitted_instance_id: int) -> void:
	var char_node = get_parent()
	
	if char_node.get_instance_id() == emitted_instance_id:
		var empty_exp_bars = []
		for child in get_children():
			if child.is_in_group("empty_exp_bar"):
				empty_exp_bars.append(child)
		
		for exp_index in range(0, char_node.exp-1):
			if len(empty_exp_bars) > exp_index:
				empty_exp_bars[exp_index].texture = load("res://src/level-fill-bar.png")

func _remove_children() -> void:
	for child in get_children():
		if child.is_in_group("empty_exp_bar"):
			child.remove_from_group("empty_exp_bar")
			child.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_add_exp_bar()
	Global.exp_added.connect(_fill_level_bar)
	Global.level_up_bar.connect(_add_exp_bar)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
