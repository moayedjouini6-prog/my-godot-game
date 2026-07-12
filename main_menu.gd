extends Control

const GAME_SCENE = "LEVELS.tscn"

func _ready():
	$StartButton.pressed.connect(_on_start_pressed)

	if has_node("ExitButton"):
		$ExitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_quit_pressed():
	get_tree().quit()
