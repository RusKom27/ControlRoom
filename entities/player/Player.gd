extends RigidBody2D

onready var run_effect_res = load("res://entities/run_effect/RunEffect.tscn")
signal item_picked(item)
signal item_dropped()

var animation_state = {
	"idle": "idle",
	"run": "run",
	"hold_idle": "hold_idle",
	"hold_run": "hold_run",
	"interact": "interact",
}

const SPEED = 250

onready var current_state = Global.STATE.IDLE
onready var current_animation = animation_state.idle
onready var animated_sprite = $AnimatedSprite
onready var interact_area = $Area2D
onready var current_item = null
onready var near_items = []

func _ready():
	animated_sprite.connect("frame_changed", self, "_on_frame_changed")
	animated_sprite.connect("animation_finished", self, "_on_animation_finished")
	interact_area.connect("body_entered", self, "_on_body_entered")
	interact_area.connect("body_exited", self, "_on_body_exited")

func _physics_process(_delta):
	if (current_item):
		current_item.rotation = 0
		current_item.position = Vector2(
			position.x, 
			position.y - 80 + (-animated_sprite.frame % 4)
		)
	
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	direction = direction.normalized()
	var motion = direction * SPEED
	set_axis_velocity(motion)
	rotation = 0
	
	if direction.x != 0:
		animated_sprite.scale.x = abs(direction.x) / direction.x
	
	if (direction.x != 0 || direction.y != 0):
		current_animation = ("hold_" if current_item else "") + animation_state.run
	else:
		current_animation = ("hold_" if current_item else "") + animation_state.idle
		
	if (current_state == Global.STATE.INTERACT):
		current_animation = animation_state.interact
		
func _on_frame_changed():
	match animated_sprite.animation:
		animation_state.run:
			if (animated_sprite.frame == 0 || animated_sprite.frame == 5):
				var run_effect = run_effect_res.instance()
				run_effect.position = position
				run_effect.scale.x = animated_sprite.scale.x
				get_parent().add_child(run_effect)
		animation_state.hold_run:
			if (animated_sprite.frame == 0 || animated_sprite.frame == 5):
				var run_effect = run_effect_res.instance()
				run_effect.position = position
				run_effect.scale.x = animated_sprite.scale.x
				get_parent().add_child(run_effect)
	animated_sprite.play(current_animation)

func _on_animation_finished():
	match animated_sprite.animation:
		animation_state.interact:
			current_state = Global.STATE.IDLE
			current_animation = animation_state.idle

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if (near_items.size() > 0):
			pickup_item(near_items[0])
			near_items.erase(0)
		elif (current_item):
			drop_item()
			

func _on_body_entered(body: RigidBody2D):
	if (body && body.is_in_group("Pickable")):
		near_items.push_back(body)

func _on_body_exited(body: RigidBody2D):
	if (body && body.is_in_group("Pickable")):
		near_items.erase(body)

func pickup_item(item):
	if (!item): return
	if (current_item):
		drop_item()
	current_item = item
	current_item.pickup()
	emit_signal("item_picked", current_item)
		
func drop_item():
	current_item.drop(animated_sprite.scale.x)
	current_item = null
	emit_signal("item_dropped")
	
	
