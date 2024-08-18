extends Area2D

func hurt(damages: int = 1):
	get_parent().hurt(damages)
