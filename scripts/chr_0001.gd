extends Node2D

const id = "0001"

@export var level = 1
@export var exp = 1
@export var health = 3
@export var attack = 1
@export var price = Global.shop_price

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("./Char").texture_normal = load("res://src/chr_0001_00.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_buy(emitted_instance_id: int):
	pass
