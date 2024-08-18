extends "res://Scenes/Utils/Mob/mob.gd"

const SPEED: int = 250

@onready var ray_cast_left: RayCast2D = $RayCastLeft

func update_state():
	if can_attack && hurt_box.get_overlapping_areas().size() > 0:
		state = State.ATTACKING
	elif is_on_floor():
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

func _on_dead():
	call_deferred("queue_free")

func _on_hurting():
	if state == State.HURTING:
		health -= 1

		if health <= 0:
			state = State.DYING
		else:
			state = State.IDLE
