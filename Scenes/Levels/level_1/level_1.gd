extends Node2D

@onready var pyromancer: Pyromancer = $Pyromancer
@onready var start_game_detector: EnvironmentalEventDetector = $StartGameDetector

func _ready():
	start_game_detector.on_entered = show_start_game

func _on_pyromancer_dead():
	call_deferred("change_scene_to_game_over")

func change_scene_to_game_over():
	if is_inside_tree():
		var tree = get_tree()

		if tree:
			tree.change_scene_to_file("res://Scenes/Screens/GameOverScreen/game_over_screen.tscn")

func _on_castle_door_open():
	pyromancer.talk("End of the game!")

func show_start_game(body):
	body.talk("Well! Let's go to this evil sorcerer!")
