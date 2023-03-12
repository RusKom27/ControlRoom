extends Area2D


onready var item_res = load("res://entities/item/Item.tscn")
var player_in_area = false

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	$AnimatedSprite.connect("animation_finished", self, "_on_animation_finished")
	$AnimatedSprite.play("off")

func _on_body_entered(body):
	if (body.name == "Player"):
		player_in_area = true
		$AnimatedSprite.play("on")

func _on_body_exited(body):
	if (body.name == "Player"):
		player_in_area = false
		$AnimatedSprite.play("off")
		

func _on_animation_finished():
	if ($AnimatedSprite.animation == "on"):
		var item = item_res.instance()
		item.type = Global.ITEM.BOMB
		item.position = $BombHole.global_position
		get_parent().get_node("YSort").add_child(item)
