extends Node2D


onready var initial_anim = false

func _ready():
	get_parent().get_node("Area2D").connect("body_entered", self, "_on_body_entered")
	get_parent().get_node("Area2D").connect("body_exited", self, "_on_body_exited")
	$AnimationPlayer.connect("animation_started", self, "_on_animator_ready")


func _process(delta):
	if (!initial_anim):
		$RichTextLabel.percent_visible = 0
		initial_anim = true

func _on_body_entered(body):
	$AnimationPlayer.play("in")

func _on_body_exited(body):
	$AnimationPlayer.play("out")
