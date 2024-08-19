extends Node

class_name SoundUtils

static func play_music(parent_node, stream: AudioStream, volume: float = 0, wait_for_end: bool = true):
	play_stream(parent_node, stream, volume, wait_for_end, "Master")

static func play_sfx(parent_node, stream: AudioStream, volume: float = 0, wait_for_end: bool = true):
	play_stream(parent_node, stream, volume, wait_for_end, "Sfx")

static func play_stream(parent_node, stream: AudioStream, volume: float = 0, wait_for_end: bool = true, bus: String = "Master"):
	var stream_player = AudioStreamPlayer.new()

	stream_player.stream = stream
	stream_player.volume_db = volume
	stream_player.bus = bus
	parent_node.add_child(stream_player)
	stream_player.play()
	if wait_for_end:
		await stream_player.finished
