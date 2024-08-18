extends EnvironmentalEventDetector

class_name CastleDoor

signal open

func _ready():
	super()

	on_entered = _on_body_entered

func can_open_for(body) -> bool:
	if !'size_level' in body:
		return false

	return body.size_level == size_level

func _on_body_entered(body):
	if can_open_for(body):
		open.emit()
	elif body.has_method("talk"):
		var message = "I can't open this door."
		if 'size_level' in body:
			if body.size_level > size_level:
				message += " I'm too big!"
			else:
				message += " I'm too small!"
		body.talk(message)
