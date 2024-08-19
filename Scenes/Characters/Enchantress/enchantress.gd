extends EnvironmentalEventDetector

class_name Enchantress

const SPEECH_SOUND = preload('res://Assets/Sfx/enchantress_speech.wav')

func _ready():
	super()

	on_entered = _on_body_entered

func _on_body_entered(_body):
	DialogManager.start_dialog(global_position,
		[
			'Help, Pyromancer!', 
			'The evil sorcerer in the distant tower has disrupted the dimensions.',
			'Break his wicked spell before the world is destroyed!'
		],
		SPEECH_SOUND
	)
