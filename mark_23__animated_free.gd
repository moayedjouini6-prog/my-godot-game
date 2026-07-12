extends Node3D

@onready var anim = $AnimationPlayer


func shoot():
	if anim.has_animation("shoot"):
		anim.stop()
		anim.play("shoot")
