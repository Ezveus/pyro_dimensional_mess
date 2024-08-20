extends Node2D

@onready var pyromancer: Pyromancer = $Pyromancer

func _ready():
	for index in ['1', '2', '3', '4']:
		var detector: EnvironmentalEventDetector = get_node('Door' + index)
		detector.on_entered = _teleport_to_indoor.bind(index)

func _teleport_to_indoor(_pyromancer, _detector, index):
	var tween = create_tween()
	tween.tween_property($Transition, 'visible', true, 0.5)
	tween.tween_callback(_end_teleportation.bind(index))

func _end_teleportation(index):
	var new_pos = get_node('Marker' + index).position
	pyromancer.position = new_pos
	pyromancer.force_fall()
	create_tween().tween_property($Transition, 'visible', false, 0.5)

func _on_pyromancer_dead():
	call_deferred("change_scene_to", "res://Scenes/Screens/GameOverScreen/game_over_screen.tscn")

func change_scene_to(path: String):
	if is_inside_tree():
		var tree = get_tree()

		if tree:
			tree.change_scene_to_file(path)

func _on_sorcerer_dead():
	if pyromancer.health > 0:
		pyromancer.talk(['Nice!', "Let's call this a day!"])
		await DialogManager.dialog_finished
		var tween = create_tween()
		tween.tween_property(self, 'modulate', Color.BLACK, 1)	
		tween.tween_callback(Callable(self, 'call_deferred').bind("change_scene_to", "res://Scenes/Screens/EndGameScreen/end_game_screen.tscn"))
