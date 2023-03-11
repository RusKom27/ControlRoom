extends KinematicBody2D

enum STATE {
	IDLE,
	RUN,
}

var animation_state = {
	"idle": "idle",
	"run": "run",
}

const SPEED = 250

onready var current_state = STATE.IDLE
onready var current_animation = animation_state.idle
onready var animated_sprite = get_node("AnimatedSprite")

func _ready():
	animated_sprite.connect("frame_changed", self, "_on_frame_changed")

func _physics_process(delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction = direction.normalized()
	var motion = direction * SPEED
	motion = move_and_slide(motion)
	
	if direction.x != 0:
		animated_sprite.scale.x = abs(direction.x) / direction.x
	
	if direction.x != 0 || direction.y != 0:
		current_animation = animation_state.run
	else:
		current_animation = animation_state.idle
		
func _on_frame_changed():
	match animated_sprite.animation:
		animation_state.run:
			if (animated_sprite.frame == 0 || animated_sprite.frame == 5):
				animated_sprite.play(current_animation)
		animation_state.idle:
			animated_sprite.play(current_animation)
