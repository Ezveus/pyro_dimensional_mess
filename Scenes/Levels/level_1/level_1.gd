extends Node2D

func _on_pyromancer_dead():
	call_deferred("change_scene_to_game_over")

func change_scene_to_game_over():
	var tree = get_tree()
	
	if tree:
		tree.change_scene_to_file("res://Scenes/Screens/GameOverScreen/game_over_screen.tscn")
