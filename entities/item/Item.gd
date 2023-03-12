extends RigidBody2D

onready var interact_area = get_node("Area2D")
var is_picked = false
var type = Global.ITEM.SCI_THING

var animations = ["sci_thing", "meat", "bomb"]

func _ready():
	randomize()
	interact_area.connect("area_entered", self, "_on_area_entered")
	interact_area.connect("area_exited", self, "_on_area_exited")
	$Image.animation = animations[type] + "_" + str(int(rand_range(0, 2)) + 1)

func _on_area_entered(area: Area2D):
	if (area.get_parent().name == "Player"):
#		 area.get_parent().near_item = self
		pass
		
func _on_area_exited(area: Area2D):
	if (area.get_parent().name == "Player"):
#		 area.get_parent().near_item = null
		pass

func pickup():
	is_picked = true
	$Area2D/CollisionShape2D.disabled = true
	
func drop(direction):
	apply_central_impulse(Vector2(2500*direction, 2000))
	$Area2D/CollisionShape2D.disabled = false
	is_picked = false
