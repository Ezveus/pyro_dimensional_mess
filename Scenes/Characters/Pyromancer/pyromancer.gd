extends "res://Scenes/Utils/Mob/mob.gd"

const SPEED = 200.0
const FIREBALL = preload('res://Scenes/Characters/Pyromancer/fireball.tscn')

@onready var recovery_timer: Timer = $RecoveryTimer
@onready var health_bar: ProgressBar = $HealthBar
@onready var casting_point: Marker2D = $CastingPoint

func _ready():
	super()

	jump_velocity = -300
	health = 3
	health_bar.max_value = health
	health_bar.value = health
	damage_rate = 50

func update_state():
	if state == State.DYING:
		return

	var direction = Input.get_axis("move_left", "move_right")

	if can_attack && Input.is_action_just_pressed("cast"):
		state = State.ATTACKING
	elif is_on_floor():
		if Input.is_action_just_pressed("jump"):
			state = State.JUMPING
		elif direction > 0:
			animated_sprite.flip_h = false
			state = State.RUNNING
		elif direction < 0:
			animated_sprite.flip_h = true
			state = State.RUNNING
		elif can_be_hurt && hurt_box.get_overlapping_areas().size() > 0:
			state = State.HURTING
		else:
			state = State.IDLE
	else:
		state = State.FALLING

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _on_hurting():
	if state == State.HURTING:
		health -= 1
		health_bar.value = health
		can_be_hurt = false
		recovery_timer.start()

		if health <= 0:
			state = State.DYING
		else:
			state = State.IDLE

func _on_recovery_timer_timeout():
	can_be_hurt = true

func do_attack():
	var fireball = FIREBALL.instantiate()

	fireball.position = casting_point.position
	casting_point.add_child(fireball)
	attack_cooldown_timer.start()
