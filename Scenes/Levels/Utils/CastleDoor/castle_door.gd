extends Area2D

const SizeUtils = preload('res://Scenes/Utils/Size/size_utils.gd')

@export var size_level: Enums.SizeLevel = Enums.SizeLevel.M

signal open

func _ready():
	##
	## Size-related stuff
	##
	update_scale()
	size_changed.connect(_on_size_changed)

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

##
## Size-related stuff
##
signal size_changed
signal size_increased
signal size_decreased

func _on_size_changed():
	update_scale()

func size_level_as_string() -> String:
	return SizeUtils.size_level_as_string(size_level)

func size() -> float:
	return SizeUtils.size(size_level)

func update_scale():
	var current_size = size()
	scale.x = current_size
	scale.y = current_size

func decrease_size(step=1):
	size_level = SizeUtils.decrease_size(size_level, step)
	size_changed.emit()
	size_decreased.emit()

func increase_size(step=1):
	size_level = SizeUtils.increase_size(size_level, step)
	size_changed.emit()
	size_increased.emit()
