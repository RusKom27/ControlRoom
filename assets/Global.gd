extends Node


enum STATE {
	IDLE,
	RUN,
	HOLD_IDLE,
	HOLD_RUN,
	INTERACT
}

enum ITEM {
	SCI_THING = 0,
	MEAT = 1,
	BOMB = 2,
}

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
