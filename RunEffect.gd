extends AnimatedSprite

func _ready():
	play("default")


func _on_RunEffect_animation_finished():
	queue_free()
