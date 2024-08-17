extends CharacterBody2D

enum State {
	IDLE = 0,
	RUNNING = 1,
	JUMPING = 2,
	FALLING = 3,
	ATTACKING = 4
}

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var state: State = State.IDLE
var health: int = 100
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	check_state(delta)
	update_state()

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
		_:
			print("Mob: Unknown state %s." % state)

func idle():
	state = State.IDLE
	animated_sprite.play("idle")

func run():
	state = State.RUNNING
	animated_sprite.play("run")
	move_and_slide()

func jump():
	state = State.JUMPING
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
