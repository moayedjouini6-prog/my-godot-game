extends Node3D

# ملف الطلقة المرتبط في الـ Inspector
@export var bullet_scene: PackedScene 
@export var spawn_radius: float = 20.0 # المسافة العشوائية حول اللاعب
@export var spawn_height: float = 3.0  # ارتفاع رسبنة الطلقة عن الأرض

@onready var timer: Timer = $Timer

func _ready() -> void:
	# نضمن أن التايمر يعمل كل ثانيتين بشكل مستمر وتلقائي
	timer.wait_time = 2.0
	timer.one_shot = false
	timer.autostart = true
	
	# ربط الإشارة برمجياً للتأكد من عملها
	if not timer.timeout.is_connected(_on_timer_timeout):
		timer.timeout.connect(_on_timer_timeout)
		
	timer.start()
	print("بدأ مؤقت رسبنة الطلقات! كل ثانيتين...")

func _on_timer_timeout() -> void:
	if not bullet_scene:
		print("خطأ: لم يتم سحب ملف bullet.tscn في الـ Inspector للـ Spawner!")
		return
	
	# البحث عن اللاعب في المشهد الحالي
	var player = get_tree().get_first_node_in_group("player")
	
	# إذا لم يجده بالجروب، سنبحث عنه بالاسم كخطة بديلة
	if not player:
		player = get_tree().current_scene.find_child("player", true, false)
		
	if not player:
		print("خطأ: لم يتم العثور على اللاعب! تأكد أن اسمه player في الـ Scene الرئيسي")
		return
	
	# حساب مكان عشوائي دائري حول اللاعب
	var random_angle = randf() * TAU
	var offset = Vector3(cos(random_angle), 0, sin(random_angle)) * spawn_radius
	var spawn_pos = player.global_position + offset
	spawn_pos.y += spawn_height # رفع الطلقة في الهواء قليلاً
	
	# صناعة ورسبنة الطلقة
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = spawn_pos
	
	print("تم رسبنة طلقة جديدة عند الموقع: ", spawn_pos)
