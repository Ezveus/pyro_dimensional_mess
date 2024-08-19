extends Control

class_name TextBox

@export var message: String
@export var letter_time: float = 0.01
@export var space_time: float = 0.04
@export var punctuation_time: float = 0.1

@onready var label: Label = $MarginContainer/Message
@onready var letter_display_timer: Timer = $LetterDisplayTimer
@onready var audio_player: AudioStreamPlayer2D = $SfxPlayer
@onready var next_indicator: AnimatedSprite2D = $NinePatchRect/Control2/NextIndicator

var letter_index = 0

const MAX_WIDTH = 256

signal finished_displaying

func display_text(text: String, speech_sfx: AudioStream):
	message = text
	label.text = message
	if speech_sfx:
		audio_player.stream = speech_sfx

	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)

	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # Wait for x resize
		await resized # Wait for y resize
		custom_minimum_size.y = size.y

	global_position.x -= size.x / 2

	# This was found through experimentation.
	var scale_delta = 22 # 9 * parent_scale * parent_scale + 13 * parent_scale
	global_position.y -= size.y + scale_delta

	label.text = ''
	letter_display_timer.start()

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
			var new_audio_player: AudioStreamPlayer2D = audio_player.duplicate()
			new_audio_player.pitch_scale += randf_range(-0.1, 0.1)
			if message[letter_index] in ['a', 'e', 'i', 'o', 'u', 'y']:
				new_audio_player.pitch_scale += 0.2
			get_tree().root.add_child(new_audio_player)
			new_audio_player.play()
			await new_audio_player.finished
			new_audio_player.queue_free()

func _on_letter_display_timer_timeout():
	_display_letter()

func finish_display():
	letter_display_timer.stop()
	label.text = message
	finished_displaying.emit()
	next_indicator.visible = true
