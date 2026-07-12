extends Node3D


func _ready() -> void:
	$AnimationPlayer.play("forever")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
