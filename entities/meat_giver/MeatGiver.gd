extends StaticBody2D


onready var item_res = load("res://entities/item/Item.tscn")
onready var player = get_node("/root/Node2D/Room/YSort/Player")
var player_in_area = false

func _ready():
	$Area2D.connect("body_entered", self, "_on_body_entered")
	$Area2D.connect("body_exited", self, "_on_body_exited")
	$AnimatedSprite.connect("animation_finished", self, "_on_animation_finished")
	$AnimatedSprite.play("idle")

func _input(event):
	if (event.is_action_pressed("ui_accept") && player_in_area):
		$AnimatedSprite.play("interact")
		player.current_state = Global.STATE.INTERACT

func _on_body_entered(body):
	if (body.name == "Player"):
		player_in_area = true

func _on_body_exited(body):
	if (body.name == "Player"):
		player_in_area = false

func _on_animation_finished():
	if ($AnimatedSprite.animation == "interact"):
		var item = item_res.instance()
		item.type = Global.ITEM.MEAT
		item.position = $MeatHole.global_position
		print(item.position, $MeatHole.position)
		get_parent().get_node("YSort").add_child(item)
		$AnimatedSprite.play("idle")
