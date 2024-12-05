extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "[font_size=80][center][b][valign px=-4]" + str(Global.coin) + "[/valign][/b][/center][/font_size]"
