extends Control

func _ready():
	$MarginContainer/Outro/ToCreditsButton.grab_focus()

func _on_to_thanks_button_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property($MarginContainer/Credits, 'visible', false, 1).set_trans(Tween.TRANS_BACK)
	tween.tween_property($MarginContainer/Thanks, 'visible', true, 1).set_trans(Tween.TRANS_BACK)
	$MarginContainer/Thanks/QuitButton.grab_focus()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_to_credits_button_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property($MarginContainer/Outro, 'visible', false, 1).set_trans(Tween.TRANS_BACK)
	tween.tween_property($MarginContainer/Credits, 'visible', true, 1).set_trans(Tween.TRANS_BACK)
	$MarginContainer/Credits/ToThanksButton.grab_focus()
