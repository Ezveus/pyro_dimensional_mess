extends Object

static func size_level_as_string(size_level: Enums.SizeLevel) -> String:
	match size_level:
		Enums.SizeLevel.XS:
			return 'XS'
		Enums.SizeLevel.S:
			return 'S'
		Enums.SizeLevel.M:
			return 'M'
		Enums.SizeLevel.L:
			return 'L'
		Enums.SizeLevel.XL:
			return 'XL'
		_:
			return 'M'

static func size(size_level: Enums.SizeLevel) -> float:
	match size_level:
		Enums.SizeLevel.XS:
			return 0.25
		Enums.SizeLevel.S:
			return 0.5
		Enums.SizeLevel.M:
			return 1
		Enums.SizeLevel.L:
			return 2
		Enums.SizeLevel.XL:
			return 4
		_:
			return 1

static func update_size(new_value):
	if new_value > Enums.SizeLevel.XL:
		new_value = Enums.SizeLevel.XL
	elif new_value < Enums.SizeLevel.XS:
		new_value = Enums.SizeLevel.XS

	return Enums.SizeLevel.values()[new_value - 1]

static func decrease_size(size_level: Enums.SizeLevel, step: int = 1):
	var new_value = int(size_level) - step

	return update_size(new_value)

static func increase_size(size_level: Enums.SizeLevel, step: int = 1):
	var new_value = int(size_level) + step

	return update_size(new_value)
