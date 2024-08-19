extends EnvironmentalEventDetector

class_name Chest

@export var opened: bool = false

@onready var closed_sprite: Sprite2D = $ClosedSprite
@onready var opened_sprite: Sprite2D = $OpenedSprite

func _ready():
	super()

	if opened:
		open()

func open():
	opened = true
	closed_sprite.visible = false
	opened_sprite.visible = true
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
