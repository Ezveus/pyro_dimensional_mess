extends EnvironmentalEventDetector

class_name CastleDoor

signal open

var counter: int = 0

func _ready():
	super()

	on_entered = try_to_open

func update_collision_shape():
	pass

func can_open_for(body) -> bool:
	if !'size_level' in body:
		return false

	return body.size_level == size_level

func try_to_open(body, _emitter):
	counter += 1

	if can_open_for(body):
		open.emit()
	else:
		var message = []

		if counter < 2:
			message.append("I can't open this door.")
		else:
			message.append("I still can't open this door.")

		if 'size_level' in body:
			if body.size_level > size_level:
				message.append("I'm too big!")
			else:
				message.append("I'm too small!")

		DialogManager.start_dialog(global_position, message)
