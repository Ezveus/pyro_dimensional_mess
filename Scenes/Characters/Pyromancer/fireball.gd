extends Area2D

const VELOCITY = 500
const RANGE = 600

var traveled_distance = 0

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * VELOCITY * delta

	traveled_distance += VELOCITY * delta

	if traveled_distance > RANGE:
		queue_free()

func _on_body_entered(body):
	queue_free()
	if body.has_method('hurt'):
		body.hurt()
