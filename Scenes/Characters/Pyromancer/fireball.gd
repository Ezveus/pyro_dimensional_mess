extends Area2D

const VELOCITY = 500
const RANGE = 600

var traveled_distance = 0

const SizeUtils = preload('res://Scenes/Utils/Size/size_utils.gd')

@export var size_level: Enums.SizeLevel = Enums.SizeLevel.M

func _ready():
	update_scale()

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * VELOCITY * delta

	traveled_distance += VELOCITY * delta

	if traveled_distance > RANGE:
		queue_free()

func _on_area_entered(area):
	queue_free()
	if area.has_method('hurt'):
		area.hurt(int(size_level))

func size() -> float:
	return SizeUtils.size(size_level)

func update_scale():
	var current_size = size()
	scale.x = current_size
	scale.y = current_size
