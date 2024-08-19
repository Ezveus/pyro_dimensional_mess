extends EnvironmentalEventDetector

class_name Chest

@export var opened: bool = false

@onready var closed_sprite: Sprite2D = $ClosedSprite
@onready var opened_sprite: Sprite2D = $OpenedSprite

const SUCCESS_SOUND = preload("res://Assets/Sfx/success.wav")

func _ready():
	super()

	if opened:
		open()

func open(player=null):
	opened = true
	closed_sprite.visible = false
	opened_sprite.visible = true
	SoundUtils.play_sfx(player if player else self, SUCCESS_SOUND, { 'wait_for_end': false })
	call_deferred('update_collision_shape')

func close():
	opened = false
	closed_sprite.visible = true
	opened_sprite.visible = false
	call_deferred('update_collision_shape')

func update_collision_shape():
	if opened:
		collision_shape.disabled = true
	else:
		collision_shape.disabled = false
