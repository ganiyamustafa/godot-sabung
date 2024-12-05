extends TextureRect


func _set_attack(char_node: Node) -> void:
	var attack_label: RichTextLabel = get_node("Attack")
	attack_label.text = "[font_size=60][valign px=-29][center][b]" + str(char_node.attack) + "[/b][/center][/valign][/font_size]"
	
func _set_health(char_node: Node) -> void:
	var attack_label: RichTextLabel = get_node("Health")
	attack_label.text = "[font_size=60][valign px=-20][center][b]" + str(char_node.health) + "[/b][/center][/valign][/font_size]"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var char_node = get_parent()
	_set_attack(char_node)
	_set_health(char_node)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
