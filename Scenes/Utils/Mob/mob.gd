extends CharacterBody2D

enum State {
	IDLE = 0,
	RUNNING = 1,
	JUMPING = 2,
	FALLING = 3,
	ATTACKING = 4,
	HURTING = 5,
	DYING = 6
}

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_box: Area2D = $Hurtbox

var state: State = State.IDLE
var health: int = 1
var jump_velocity : int = -100
var damage_rate: int = 10
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_be_hurt = true

signal hurting
signal dead

func _physics_process(delta):
	print("[%s] _physics_process[0]: Current state: %s" % [name, state_as_string()])
	check_state(delta)
	print("[%s] _physics_process[1]: Current state: %s" % [name, state_as_string()])
	update_state()
	print("[%s] _physics_process[2]: Current state: %s" % [name, state_as_string()])

func state_as_string():
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
			print("[%s] check_state: Unknown state: %d" % [name, state])

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
	state = State.ATTACKING
	animated_sprite.play("attack")

func hurt():
	if can_be_hurt:
		state = State.HURTING
		animated_sprite.play('hurt')
		for ennemy in hurt_box.get_overlapping_bodies():
			if ennemy.has_method('attack'):
				ennemy.attack()
		hurting.emit()

func die():
	state = State.DYING
	animated_sprite.play('death')
	dead.emit()
