extends Node2D

@onready var pyromancer: Pyromancer = $Pyromancer
@onready var start_game_detector: EnvironmentalEventDetector = $StartGameDetector
@onready var centaur_detector: EnvironmentalEventDetector = $CentaurDetector
@onready var giant_centaur_detector: EnvironmentalEventDetector = $GiantCentaurDetector

func _ready():
	start_game_detector.on_entered = show_start_game
	centaur_detector.on_entered = show_cast_tuto
	giant_centaur_detector.on_entered = show_size_tuto

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
	body.talk("Well! Let's jump (press Space) to this evil sorcerer!")

func show_cast_tuto(body):
	body.talk("Centaurs! If our eyes meet, they'll charge at me. Fortunately, a fireball (press Ctrl) will solve the problem.")

func show_size_tuto(body):
	body.talk("By Pyrrhos! This centaur is gigantic! Surely an effect of the dimensional spell. I’m going to need a few more fireballs...")
