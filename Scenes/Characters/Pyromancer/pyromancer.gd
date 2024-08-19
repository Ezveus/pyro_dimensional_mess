extends "res://Scenes/Utils/Mob/mob.gd"

class_name Pyromancer

const FIREBALL = preload('res://Scenes/Characters/Pyromancer/fireball.tscn')
const TEXT_BOX = preload('res://Scenes/Utils/TextBox/text_box.tscn')
const SPEECH_SOUND = preload('res://Assets/Sfx/pyromancer_speech.wav')

@onready var recovery_timer: Timer = $RecoveryTimer
@onready var casting_point: Marker2D = $CastingPoint

func _ready():
	super()

	jump_velocity = jump_velocity_from_size()
	speed = 200
	health = int(size_level)
	damage_rate = 50
	orientation = 1

func update_state():
	if DialogManager.is_dialog_active:
		state = State.IDLE
		return

	if state == State.DYING:
		return

	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		orientation = direction

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
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func do_attack():
	var fireball = FIREBALL.instantiate()

	fireball.global_position = casting_point.global_position
	fireball.rotation_degrees = (180 if orientation < 0 else 0)
	fireball.size_level = size_level
	get_parent().add_child(fireball)
	attack_cooldown_timer.start()

func talk(messages) -> TextBox:
	if messages is String:
		messages = [messages]

	return DialogManager.start_dialog(global_position, messages, SPEECH_SOUND)

func jump_velocity_from_size() -> int:
	match size_level:
		Enums.SizeLevel.XS:
			return -500
		Enums.SizeLevel.S:
			return -400
		Enums.SizeLevel.M:
			return -325
		Enums.SizeLevel.L:
			return -275
		Enums.SizeLevel.XL:
			return -350
		_:
			return -500

func _on_hurting(damages=1):
	if state == State.HURTING:
		health -= damages
		decrease_size()
		can_be_hurt = false
		recovery_timer.start()

		if health <= 0:
			force_state = State.DYING
		else:
			state = State.IDLE

func _on_recovery_timer_timeout():
	can_be_hurt = true

func _on_size_decreased():
	super()

	jump_velocity = jump_velocity_from_size()

func _on_size_increased():
	super()

	jump_velocity = jump_velocity_from_size()
