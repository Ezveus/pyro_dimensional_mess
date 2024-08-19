extends Node2D

@onready var pyromancer: Pyromancer = $Pyromancer
@onready var start_game_detector: EnvironmentalEventDetector = $StartGameDetector
@onready var centaur_detector: EnvironmentalEventDetector = $CentaurDetector
@onready var giant_centaur_detector: EnvironmentalEventDetector = $GiantCentaurDetector
@onready var chest: Chest = $Chest
@onready var shrink_potion: Potion = $ShrinkPotion
@onready var shrink_potion2: Potion = $ShrinkPotion2

func _ready():
	start_game_detector.on_entered = show_start_game
	centaur_detector.on_entered = show_cast_tuto
	giant_centaur_detector.on_entered = show_size_tuto
	chest.on_entered = become_big
	shrink_potion.on_entered = become_small
	shrink_potion2.on_entered = become_small

func _on_pyromancer_dead():
	call_deferred("change_scene_to_game_over")

func change_scene_to_game_over():
	if is_inside_tree():
		var tree = get_tree()

		if tree:
			tree.change_scene_to_file("res://Scenes/Screens/GameOverScreen/game_over_screen.tscn")

func _on_castle_door_open():
	pyromancer.talk("End of the game!")

func show_start_game(body, _emitter):
	body.talk("Well! Let's jump (press Space) to this evil sorcerer!")

func show_cast_tuto(body, _emitter):
	body.talk("Centaurs! If our eyes meet, they'll charge at me. Fortunately, a fireball (press Ctrl) will solve the problem.")

func show_size_tuto(body, _emitter):
	body.talk("By Pyrrhos! This centaur is gigantic! Surely an effect of the dimensional spell. I’m going to need a few more fireballs...")

func become_big(body, emitter):
	if body is Pyromancer:
		emitter.open()
		body.increase_size(2)
		body.talk("WHAT! I'M SO BIG! NOW I WILL BURN THOSE BIG CENTAURS WITH EASE.")

func become_small(body, emitter):
	if body is Pyromancer:
		emitter.drink()
		body.decrease_size(1)
