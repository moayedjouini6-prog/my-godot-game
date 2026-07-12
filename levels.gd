extends Control

const GAME_SCENE = "res://main.tscn" 
const main_menu = "res://main_menu.tscn"
func _ready():
	$LEVEL1.pressed.connect(_on_start_pressed)

	if has_node("QuitButton"):
		$QuitButton.pressed.connect(_on_quit_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_quit_pressed():
	get_tree().change_scene_to_file(main_menu)
