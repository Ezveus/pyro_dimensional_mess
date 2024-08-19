extends EnvironmentalEventDetector

class_name CastleDoor

signal open

var counter: int = 0

const DOOR_CLOSED_SFX: AudioStream = preload('res://Assets/Sfx/door_closed.wav')
const DOOR_OPENED_SFX: AudioStream = preload('res://Assets/Sfx/door_opened.wav')

func _ready():
	super()

	on_entered = try_to_open

func update_collision_shape():
	pass

func can_open_for(body) -> bool:
	if !'size_level' in body:
		return false

	return body.size_level == size_level

func try_to_open(body, emitter):
	counter += 1

	if can_open_for(body):
		SoundUtils.play_sfx(emitter, DOOR_OPENED_SFX, { 'volume_db': 10, 'wait_for_end': false })
		open.emit()
	else:
		SoundUtils.play_sfx(emitter, DOOR_CLOSED_SFX, { 'volume_db': 25, 'wait_for_end': false })

		if body is Pyromancer:
			var message = []

			if counter < 2:
				message.append("I can't open this door.")
			else:
				message.append("I still can't open this door.")

			if body.size_level > size_level:
				message.append("I'm too big!")
			else:
				message.append("I'm too small!")

			body.talk(message)
