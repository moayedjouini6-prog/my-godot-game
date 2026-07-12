extends Area3D

@export var speed: float = 6.0
@export var damage: int = 1

var target_player: Node3D = null
var destroyed: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

	target_player = get_tree().get_first_node_in_group("player")
	if target_player == null:
		target_player = get_tree().current_scene.find_child("player", true, false)

	get_tree().create_timer(6.0).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	if destroyed:
		return

	if target_player:
		var target_pos = target_player.global_position
		target_pos.y += 1.0

		var direction = (target_pos - global_position).normalized()
		global_position += direction * speed * delta
		look_at(target_pos, Vector3.UP)

func hit_by_player() -> void:
	if destroyed:
		return

	destroyed = true

	# Disable this Area
	monitoring = false
	monitorable = false

	# Disable collision
	$CollisionShape3D.set_deferred("disabled", true)

	# Hide bullet
	visible = false

	# Delete it
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if destroyed:
		return

	if body.is_in_group("player") or body.has_method("take_damage") or body.name == "player":
		body.take_damage(damage)
		queue_free()
	elif body is StaticBody3D or body.name == "floor":
		queue_free()
