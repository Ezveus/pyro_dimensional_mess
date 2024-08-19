extends EnvironmentalEventDetector

class_name Sign

func _ready():
	super()

	on_entered = _on_body_entered

func _on_body_entered(_body):
	DialogManager.start_dialog(global_position,
		['Press Enter to close a dialog']
	)
