extends Node

const PRESSED_SFX: AudioStream = preload('res://Assets/Sfx/menu_confirm.wav')
const HOVERED_SFX: AudioStream = preload('res://Assets/Sfx/menu_hover.wav')

func _ready():
# when _ready is called, there might already be nodes in the tree, so connect all existing buttons
	connect_buttons(get_tree().root)
	get_tree().node_added.connect(_on_SceneTree_node_added)

func _on_SceneTree_node_added(node):
	if node is BaseButton:
		connect_to_button(node)

func _on_BaseButton_pressed(button):
	SoundUtils.play_sfx(button, PRESSED_SFX, { '2D': false })

func _on_BaseButton_hovered(button):
	SoundUtils.play_sfx(button, HOVERED_SFX, { '2D': false })

# recursively connect all buttons
func connect_buttons(root):
	for child in root.get_children():
		if child is BaseButton:
			connect_to_button(child)
		connect_buttons(child)

func connect_to_button(button: BaseButton):
	button.pressed.connect(_on_BaseButton_pressed.bind(button))
	button.mouse_entered.connect(_on_BaseButton_hovered.bind(button))
