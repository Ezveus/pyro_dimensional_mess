extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -250.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var original_position = Vector2(0, 0)

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	print("Ready 1: X: %d, Y: %d" % [original_position.x, original_position.y])
	original_position.x = position.x
	original_position.y = position.y
	print("Ready 2: X: %d, Y: %d" % [original_position.x, original_position.y])

func _physics_process(delta):
	# Input direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")

	# Add the gravity.
	if is_on_floor():
		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			animated_sprite.play('jump')
			velocity.y = JUMP_VELOCITY
		elif direction == 0:
			animated_sprite.play('idle')
		else:
			animated_sprite.play('walk')
	else:
		animated_sprite.play('jump')
		velocity.y += gravity * delta

	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func reset():
	position.x = original_position.x
	position.y = original_position.y
	print("Reset: X: %d, Y: %d" % [original_position.x, original_position.y])
