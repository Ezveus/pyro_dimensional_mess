extends EnvironmentalEventDetector

class_name CastleDoor

signal open

var counter: int = 0

const DOOR_CLOSED_SFX: AudioStream = preload('res://Assets/Sfx/door_closed.wav')
const DOOR_OPENED_SFX: AudioStream = preload('res://Assets/Sfx/door_opened.wav')

@onready var sfx_player: AudioStreamPlayer = $SfxPlayer

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
		play_sfx(DOOR_OPENED_SFX, 25)
		open.emit()
	else:
		play_sfx(DOOR_CLOSED_SFX, 100)

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

func play_sfx(sfx: AudioStream, volume: float = 0):
	sfx_player.stream = sfx
	sfx_player.volume_db = volume
	sfx_player.play()
	await sfx_player.finished
