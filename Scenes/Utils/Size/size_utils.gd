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
