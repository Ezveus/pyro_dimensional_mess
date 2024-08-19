extends Node

const TEXT_BOX = preload("res://Scenes/Utils/TextBox/text_box.tscn")

var dialog_lines: Array[String] = []
var current_line_index = 0

var text_box: TextBox
var text_box_position: Vector2

var sfx: AudioStream

var is_dialog_active: bool = false
var can_advance_line: bool = false

signal dialog_finished

func start_dialog(position: Vector2, lines: Array, speech_sfx: AudioStream) -> TextBox:
	if is_dialog_active:
		return text_box

	dialog_lines.assign(lines)
	text_box_position = position
	sfx = speech_sfx
	show_text_box()

	is_dialog_active = true
	return text_box

func show_text_box():
	text_box = TEXT_BOX.instantiate()

	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index], sfx)
	can_advance_line = false

func _on_text_box_finished_displaying():
	can_advance_line = true

func _unhandled_key_input(event):
	if !event.is_action_pressed('advance_dialog'):
		return

	if is_dialog_active:
		if can_advance_line:
			text_box.queue_free()

			current_line_index += 1
			if current_line_index >= dialog_lines.size():
				is_dialog_active = false
				current_line_index = 0
				dialog_finished.emit()
				return

			show_text_box()
		else:
			text_box.finish_display()
