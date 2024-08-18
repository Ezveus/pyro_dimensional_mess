extends CharacterBody2D

class_name Mob

enum State {
	IDLE,
	RUNNING,
	JUMPING,
	FALLING,
	ATTACKING,
	HURTING,
	DYING
}

enum SizeLevel {
	XS,
	S,
	M,
	L,
	XL
}

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_box: Area2D = $Hurtbox
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer

@export var size_level: SizeLevel = SizeLevel.M

@export var debug = false

var state: State = State.IDLE
var health: int = 1
var jump_velocity : int = -100
var damage_rate: int = 10
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_be_hurt = true
var can_attack = true

signal hurting
signal dead

func _ready():
	hurt_box.area_entered.connect(_on_hurtbox_area_entered)
	attack_cooldown_timer.timeout.connect(_on_attack_cooldown_timer_timeout)
	scale.x = size()
	scale.y = size()

func _physics_process(delta):
	debug_message("_physics_process[0]: Current state: %s" % state_as_string())
	check_state(delta)
	debug_message("_physics_process[1]: Current state: %s" % state_as_string())
	update_state()
	debug_message("_physics_process[2]: Current state: %s" % state_as_string())

func debug_message(message):
	if !debug:
		return

	print("[%s] %s" % [name, message])

func state_as_string() -> String:
	match state:
		State.IDLE:
			return 'IDLE'
		State.RUNNING:
			return 'RUNNING'
		State.JUMPING:
			return 'JUMPING'
		State.FALLING:
			return 'FALLING'
		State.ATTACKING:
			return 'ATTACKING'
		State.HURTING:
			return 'HURTING'
		State.DYING:
			return 'DYING'
		_:
			return ''

func size_level_as_string() -> String:
	match size_level:
		SizeLevel.XS:
			return 'XS'
		SizeLevel.S:
			return 'S'
		SizeLevel.M:
			return 'M'
		SizeLevel.L:
			return 'L'
		SizeLevel.XL:
			return 'XL'
		_:
			return 'M'

func size() -> float:
	match size_level:
		SizeLevel.XS:
			return 0.25
		SizeLevel.S:
			return 0.5
		SizeLevel.M:
			return 1
		SizeLevel.L:
			return 2
		SizeLevel.XL:
			return 4
		_:
			return 1

func update_state():
	pass

func check_state(delta):
	match state:
		State.IDLE:
			idle()
		State.RUNNING:
			run()
		State.JUMPING:
			jump()
		State.FALLING:
			fall(delta)
		State.ATTACKING:
			attack()
		State.HURTING:
			hurt()
		State.DYING:
			die()
		_:
			debug_message("check_state: Unknown state: %d" % state)

func idle():
	state = State.IDLE
	animated_sprite.play("idle")

func run():
	state = State.RUNNING
	animated_sprite.play("run")
	move_and_slide()

func jump():
	state = State.JUMPING
	velocity.y = jump_velocity
	animated_sprite.play("jump")
	move_and_slide()

func fall(delta):
	velocity.y += gravity * delta
	state = State.FALLING
	# Using same animation for jumping and falling
	animated_sprite.play("jump")
	move_and_slide()

func attack():
	if can_attack:
		can_attack = false
		state = State.ATTACKING
		animated_sprite.play("attack")
		do_attack()

func do_attack():
	attack_cooldown_timer.start()

func hurt():
	if can_be_hurt:
		state = State.HURTING
		animated_sprite.play('hurt')
		hurting.emit()

func die():
	state = State.DYING
	animated_sprite.play('death')
	dead.emit()

func _on_hurtbox_area_entered(_body):
	state = State.HURTING

func _on_attack_cooldown_timer_timeout():
	can_attack = true
