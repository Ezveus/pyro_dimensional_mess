extends EnvironmentalEventDetector

class_name Potion

enum Type {
	EMPTY,
	SHRINK,
	GROW
}

const SUCCESS_SOUND = preload("res://Assets/Sfx/success.wav")

@onready var sprite: Sprite2D = $Sprite

@export var type: Type = Type.EMPTY:
	get:
		return type
	set(value):
		type = value
		if sprite:
			update_sprite()

func _ready():
	super()

	update_sprite()

func drink(player):
	SoundUtils.play_sfx(player, SUCCESS_SOUND, { 'wait_for_end': false })
	call_deferred('queue_free')

func update_sprite():
	match type:
		Type.SHRINK:
			sprite.texture.region.position.x = 81
		Type.GROW:
			sprite.texture.region.position.x = 97
		_:
			sprite.texture.region.position.x = 17
