extends "res://Scenes/Utils/Mob/mob.gd"

class_name Sorcerer

const FIREBALL = preload('res://Scenes/Characters/Pyromancer/fireball.tscn')
@onready var shape_cast = $ShapeCast
@onready var casting_point = $CastingPoint

func _ready():
	health = 3

func update_state():
	if is_on_floor():
		scan_for_enemies()
	else:
		state = State.FALLING

func scan_for_enemies():
	if shape_cast.is_colliding():
		state = State.ATTACKING
	else:
		state = State.IDLE

func _on_dead():
	call_deferred("queue_free")

func do_attack():
	var fireball = FIREBALL.instantiate()

	fireball.parent = self
	fireball.global_position = casting_point.global_position
	fireball.global_position.y += randf_range(-100, 100)
	fireball.rotation_degrees = 180
	get_parent().add_child(fireball)
	attack_cooldown_timer.start()

func _on_hurtbox_area_entered(body):
	if body is Fireball:
		state = State.HURTING

func _on_hurting(_damages):
	if state == State.HURTING:
		health -= 1

		if health <= 0:
			force_state = State.DYING
		else:
			state = State.IDLE
