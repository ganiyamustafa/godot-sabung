extends Node2D

const id = "0000"

@export var level = 1
@export var exp = 1
@export var health = 2
@export var attack = 2
@export var price = Global.shop_price

func _on_buy(emitted_instance_id: int):
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("./Char").texture_normal = load("res://src/chr_0000_00.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
