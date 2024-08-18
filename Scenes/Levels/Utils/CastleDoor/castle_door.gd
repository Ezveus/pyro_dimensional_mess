extends Area2D

const SizeUtils = preload('res://Scenes/Utils/Size/size_utils.gd')

@export var size_level: Enums.SizeLevel = Enums.SizeLevel.M

signal open

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
