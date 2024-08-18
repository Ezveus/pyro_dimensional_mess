extends Control

@export var message: String
@export var letter_time: float = 0.03
@export var space_time: float = 0.06
@export var punctuation_time: float = 0.2
@export var expires_in: int = 10
@export var active: bool = false

@onready var label: Label = $MarginContainer/Message
@onready var active_timer: Timer = $ActiveTimer
@onready var letter_display_timer: Timer = $LetterDisplayTimer

var letter_index = 0

const MAX_WIDTH = 256

signal finished_displaying

func _on_timer_timeout():
	call_deferred('queue_free')

func activate():
	active = true
	active_timer.start()

func deactivate():
	active = false
	active_timer.stop()

func display_text(text: String, parent_scale: int = 1):
	message = text
	label.text = message

	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)

	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # Wait for x resize
		await resized # Wait for y resize
		custom_minimum_size.y = size.y

	global_position.x -= size.x / 2

	# This was found through experimentation.
	var scale_delta = 9 * parent_scale * parent_scale + 13 * parent_scale
	global_position.y -= size.y + scale_delta

	label.text = ''
	letter_display_timer.start()

func _display_letter():
	label.text += message[letter_index]

	letter_index += 1
	if letter_index >= message.length():
		finished_displaying.emit()
		return

	match message[letter_index]:
		"!", ",", ".", "?", ":", ";":
			letter_display_timer.start(punctuation_time)
		" ":
			letter_display_timer.start(space_time)
		_:
			letter_display_timer.start(letter_time)

func _on_letter_display_timer_timeout():
	_display_letter()

func _on_finished_displaying():
	activate()
