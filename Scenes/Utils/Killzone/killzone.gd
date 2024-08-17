extends Area2D

@onready var timer = $Timer
var player

func _on_body_entered(body):
	print('Death')
	Engine.time_scale = 0.25
	#body.get_node('CollisionShape2D').queue_free()
	player = body
	timer.start()

func _on_timer_timeout():
	Engine.time_scale = 1
	if player:
		player.reset()
