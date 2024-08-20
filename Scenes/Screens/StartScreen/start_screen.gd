extends Control

func _ready():
	$VBoxContainer/PlayButton.grab_focus()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_play_button_pressed():
	call_deferred("change_scene_to", "res://Scenes/Levels/Level1/level_1.tscn")

func change_scene_to(path: String):
	if is_inside_tree():
		var tree = get_tree()

		if tree:
			tree.change_scene_to_file(path)
