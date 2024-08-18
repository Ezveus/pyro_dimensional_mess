extends EnvironmentalEventDetector

class_name Enchantress

func _ready():
	super()

	on_entered = _on_body_entered

func _on_body_entered(body):
	body.talk('Help, Pyromancer! The evil sorcerer in the distant tower has disrupted the dimensions. Break his wicked spell before the world is destroyed!')
