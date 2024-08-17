extends Control

func _ready():
	$VBoxContainer/TryAgainButton.grab_focus()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_try_again_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1/level_1.tscn")
