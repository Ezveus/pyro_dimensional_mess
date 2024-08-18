extends Area2D

##
## Detect when a player enters it and calls an event
##
class_name EnvironmentalEventDetector

const SizeUtils = preload('res://Scenes/Utils/Size/size_utils.gd')

@export var size_level: Enums.SizeLevel = Enums.SizeLevel.M
@export var on_entered: Callable:
	get:
		return on_entered
	set(callable):
		if on_entered && body_entered.is_connected(on_entered):
			body_entered.disconnect(on_entered)
		on_entered = callable
		if on_entered:
			body_entered.connect(on_entered)

func _ready():
	##
	## Size-related stuff
	##
	update_scale()
	size_changed.connect(_on_size_changed)

	if on_entered:
		body_entered.connect(on_entered)

#
# Size-related stuff
#
signal size_changed
signal size_increased
signal size_decreased

func _on_size_changed():
	update_scale()

func size_level_as_string() -> String:
	return SizeUtils.size_level_as_string(size_level)

func size() -> float:
	return SizeUtils.size(size_level)

func update_scale():
	var current_size = size()
	scale.x = current_size
	scale.y = current_size

func decrease_size(step=1):
	size_level = SizeUtils.decrease_size(size_level, step)
	size_changed.emit()
	size_decreased.emit()

func increase_size(step=1):
	size_level = SizeUtils.increase_size(size_level, step)
	size_changed.emit()
	size_increased.emit()
