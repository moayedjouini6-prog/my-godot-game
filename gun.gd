extends Node3D

# --- إعدادات الذخيرة والسرعة ---
@export var MAX_AMMO : int = 10
@export var FIRE_RATE : float = 0.15

var current_ammo : int = MAX_AMMO
var is_reloading : bool = false
var can_shoot : bool = true

# --- التوقيت الدقيق للانميشن ---
const SHOOT_START_TIME : float = 3.70

# --- ربط العقد ---
@onready var anim_player: AnimationPlayer = $AnimationPlayer2
@onready var ammo_label: Label = $"../../../CanvasLayer/Label"

# RayCast الخاص بالسلاح
@onready var raycast: RayCast3D = $RayCast3D

func _ready() -> void:
	current_ammo = MAX_AMMO
	update_ammo_ui()

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_R) and current_ammo < MAX_AMMO and not is_reloading:
		reload()

func shoot() -> void:
	if is_reloading or not can_shoot:
		return

	if current_ammo <= 0:
		reload()
		return

	can_shoot = false

	anim_player.play("Shoot")
	anim_player.seek(SHOOT_START_TIME, true)

	current_ammo -= 1
	update_ammo_ui()

	# -------- RayCast --------
	raycast.force_raycast_update()

	if raycast.is_colliding():
		var collider = raycast.get_collider()

		# Walk up the node tree until we find hit_by_player()
		var node = collider
		while node:
			if node.has_method("hit_by_player"):
				node.hit_by_player()
				break
			node = node.get_parent()
	# -------------------------

	await get_tree().create_timer(FIRE_RATE).timeout
	can_shoot = true

	if current_ammo == 0:
		reload()
func reload() -> void:
	if is_reloading:
		return

	is_reloading = true

	if ammo_label:
		ammo_label.text = "RELOADING..."

	if anim_player and anim_player.has_animation("Reload"):
		anim_player.play("Reload")
		await anim_player.animation_finished
	else:
		await get_tree().create_timer(1.2).timeout

	current_ammo = MAX_AMMO
	is_reloading = false
	can_shoot = true
	update_ammo_ui()

func update_ammo_ui() -> void:
	if ammo_label:
		ammo_label.text = str(current_ammo) + " / " + str(MAX_AMMO)
