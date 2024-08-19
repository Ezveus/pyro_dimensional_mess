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

const SizeUtils = preload('res://Scenes/Utils/Size/size_utils.gd')
const JUMP_SOUND = preload("res://Assets/Sfx/jump.wav")
const HURT_SOUND = preload("res://Assets/Sfx/hit.wav")
const SIZE_DECREASED_SFX = preload("res://Assets/Sfx/size_decrease.wav")
const SIZE_INCREASED_SFX = preload("res://Assets/Sfx/size_increase.wav")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_box: Area2D = $Hurtbox
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer

@export var size_level: Enums.SizeLevel = Enums.SizeLevel.M

@export var debug = false

var force_state: State = State.IDLE
var state: State = State.IDLE
var health: int = 1
var jump_velocity : int = -100
var damage_rate: int = 10
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var orientation: float = -1
var can_be_hurt = true
var can_attack = true

signal hurting(damages: int)
signal dead

func _ready():
	health = int(size_level)
	hurt_box.area_entered.connect(_on_hurtbox_area_entered)
	attack_cooldown_timer.timeout.connect(_on_attack_cooldown_timer_timeout)

	##
	## Size-related stuff
	##
	update_scale()
	size_increased.connect(_on_size_increased)
	size_decreased.connect(_on_size_decreased)

func _physics_process(delta):
	debug_message("_physics_process[-1]: Current state: %s, force_state: %s" % [state_as_string(), state_as_string(force_state)])
	if force_state != State.IDLE:
		state = force_state
		force_state = State.IDLE

	debug_message("_physics_process[0]: Current state: %s" % state_as_string())
	check_state(delta)
	debug_message("_physics_process[1]: Current state: %s" % state_as_string())
	update_state()
	debug_message("_physics_process[2]: Current state: %s" % state_as_string())

func debug_message(message):
	if !debug:
		return

	print("[%s] %s" % [name, message])

func state_as_string(st: State = state) -> String:
	match st:
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
	SoundUtils.play_sfx(self, JUMP_SOUND, { 'wait_for_end': false })
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

func hurt(damages: int = 1):
	if can_be_hurt:
		state = State.HURTING
		animated_sprite.play('hurt')
		SoundUtils.play_sfx(self, HURT_SOUND, { 'wait_for_end': false })
		hurting.emit(damages)

func die():
	state = State.DYING
	animated_sprite.play('death')
	dead.emit()

##
## Signal callbacks
##
func _on_hurtbox_area_entered(_body):
	state = State.HURTING

func _on_attack_cooldown_timer_timeout():
	can_attack = true

##
## Size-related stuff
##
signal size_increased
signal size_decreased

func _on_size_increased():
	SoundUtils.play_sfx(get_tree().root, SIZE_INCREASED_SFX, { 'wait_for_end': false })
	update_scale(true)

func _on_size_decreased():
	SoundUtils.play_sfx(get_tree().root, SIZE_DECREASED_SFX, { 'wait_for_end': false })
	update_scale(false)

func size_level_as_string() -> String:
	return SizeUtils.size_level_as_string(size_level)

func size() -> float:
	return SizeUtils.size(size_level)

func sprite_size():
	return $AnimatedSprite2D.sprite_frames.get_frame_texture('idle', 0).get_size() * $AnimatedSprite2D.scale

func update_scale(increased: bool = false):
	var target_scale = size()
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(target_scale, target_scale), 1)
	tween.tween_callback(Callable(self, 'escape_from_ground').bind(increased))

func escape_from_ground(increased: bool = false):
	if increased:
		position.y -= sprite_size().y - 10
		move_and_slide()
	else:
		force_state = State.FALLING

func decrease_size(step=1):
	size_level = SizeUtils.decrease_size(size_level, step)
	size_decreased.emit()

func increase_size(step=1):
	size_level = SizeUtils.increase_size(size_level, step)
	size_increased.emit()
