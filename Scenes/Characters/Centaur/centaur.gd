extends "res://Scenes/Utils/Mob/mob.gd"

const SPEED: int = 250

@onready var ray_cast_left: RayCast2D = $RayCastLeft

func update_state():
	if is_on_floor():
		scan_for_enemies()
	else:
		state = State.FALLING

func scan_for_enemies():
	var collider = null

	if ray_cast_left.is_colliding():
		collider = ray_cast_left.get_collider()

		state = State.RUNNING
		velocity = global_position.direction_to(collider.global_position) * SPEED
	else:
		state = State.IDLE
