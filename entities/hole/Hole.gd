extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	

func _on_body_entered(body: RigidBody2D):
	if (body && body.is_in_group("Pickable") && !body.is_picked):
		body.queue_free()



