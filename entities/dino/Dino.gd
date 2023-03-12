extends StaticBody2D

onready var player = get_node("/root/Node2D/Room/YSort/Player")

var animations = {
	"idle": "idle",
	"mouse_up": "mouse_up",
	"mouse_down": "mouse_down",
	"eating": "eating"
}

var eating_item = null
var near_items = []
var current_animation = animations.idle

func _ready():
	player.connect("item_picked", self, "_on_player_item_picked")
	player.connect("item_dropped", self, "_on_player_item_dropped")
	$AnimatedSprite.connect("animation_finished", self, "_on_animation_finished")
	$Area2D.connect("body_entered", self, "_on_body_entered")
	$Area2D.connect("body_exited", self, "_on_body_exited")


func _on_player_item_picked(item):
	current_animation = animations.mouse_up
	
func _on_player_item_dropped():
	current_animation = animations.mouse_down
	
func _on_animation_finished():
	match $AnimatedSprite.animation:
		"mouse_down":
			if (eating_item):
				current_animation = animations.eating
			else:
				current_animation = animations.idle
		"eating":
			if (near_items.size() > 0):
				eating_item = near_items[0]
			else:
				eating_item = null
	$AnimatedSprite.play(current_animation)
func _on_body_entered(body: RigidBody2D):
	if (body && body.is_in_group("Pickable")):
		near_items.push_back(body)
		if (!eating_item):
			eating_item = near_items[0]
			current_animation = "eating"
			eating_item.queue_free()
	print(near_items)
	
func _on_body_exited(body: RigidBody2D):
	if (body && body.is_in_group("Pickable")):
		near_items.remove(near_items.find(body))
	


