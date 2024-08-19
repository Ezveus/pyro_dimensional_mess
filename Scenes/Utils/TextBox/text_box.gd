extends Control

class_name TextBox

@export var message: String
@export var letter_time: float = 0.01
@export var space_time: float = 0.04
@export var punctuation_time: float = 0.1

@onready var label: Label = $MarginContainer/Message
@onready var letter_display_timer: Timer = $LetterDisplayTimer
@onready var next_indicator: AnimatedSprite2D = $NinePatchRect/Control2/NextIndicator

var letter_index = 0
@export var stream: AudioStream

const MAX_WIDTH = 256

signal finished_displaying

func _ready():
	scale = Vector2.ZERO

func display_text(text: String, speech_sfx: AudioStream):
	message = text
	label.text = message
	stream = speech_sfx

	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)

	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # Wait for x resize
		await resized # Wait for y resize
		custom_minimum_size.y = size.y

	global_position.x -= size.x / 2
	global_position.y -= size.y + 32

	label.text = ''

	pivot_offset = Vector2(size.x / 2, size.y)

	var tween = get_tree().create_tween()
	tween.tween_property(self, 'scale', Vector2.ONE, 0.15).set_trans(Tween.TRANS_BACK)

	_display_letter()

func _display_letter():
	label.text += message[letter_index]

	letter_index += 1
	if letter_index >= message.length():
		finished_displaying.emit()
		next_indicator.visible = true
		return

	match message[letter_index]:
		"!", ",", ".", "?", ":", ";":
			letter_display_timer.start(punctuation_time)
		" ":
			letter_display_timer.start(space_time)
		_:
			letter_display_timer.start(letter_time)

			var pitch_scale: float = 1 + randf_range(-0.1, 0.1)
			if message[letter_index] in ['a', 'e', 'i', 'o', 'u', 'y']:
				pitch_scale += 0.2

			SoundUtils.play_speech(get_tree().root, stream, {
				'pitch_scale': pitch_scale
			})

func _on_letter_display_timer_timeout():
	_display_letter()

func finish_display():
	letter_display_timer.stop()
	label.text = message
	finished_displaying.emit()
	next_indicator.visible = true
