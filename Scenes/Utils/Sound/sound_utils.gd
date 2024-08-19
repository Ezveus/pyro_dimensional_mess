extends Node

class_name SoundUtils

static func play_speech(parent_node, stream: AudioStream, config: Dictionary = {}):
	config.merge({ 'bus': 'Speech' }, true)
	play_stream(parent_node, stream, config)

static func play_music(parent_node, stream: AudioStream, config: Dictionary = {}):
	play_stream(parent_node, stream, config)

static func play_sfx(parent_node, stream: AudioStream, config: Dictionary = {}):
	config.merge({ 'bus': 'Sfx' }, true)
	play_stream(parent_node, stream, config)

static func play_stream(parent_node, stream: AudioStream, config: Dictionary = {}):
	var stream_player = AudioStreamPlayer.new()

	stream_player.stream = stream
	parent_node.add_child(stream_player)

	for property in config:
		if property in stream_player:
			stream_player.set(property, config[property])

	if config.has('wait_for_end') && config['wait_for_end'] == false:
		stream_player.finished.connect(func(): stream_player.queue_free())
		stream_player.play()
	else:
		stream_player.play()
		await stream_player.finished
		stream_player.queue_free()
