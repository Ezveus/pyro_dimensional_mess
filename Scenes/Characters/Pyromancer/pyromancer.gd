extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const DAMAGE_RATE = 10.0

var health = 100.0

signal hurting
signal dead

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_box: Area2D = $Hurtbox

func _physics_process(delta):
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

	take_damage_from_mobs(delta)

func take_damage_from_mobs(delta):
	var overlapping_mobs = hurt_box.get_overlapping_bodies()
	var damage_count = DAMAGE_RATE * overlapping_mobs.size() * delta

	if damage_count > 0:
		for mob in overlapping_mobs:
			if mob.has_method('attack'):
				mob.attack()
		health -= damage_count
		animated_sprite.play('hurt')
		hurting.emit()
	else:
		animated_sprite.play('idle')

	if health <= 0:
		dead.emit()

func die():
	animated_sprite.play('death')
	dead.emit()
