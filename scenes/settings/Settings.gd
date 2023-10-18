extends Panel

@onready var game_data: GameData = get_node("/root/GameData")
@onready var fullscreen = $VBoxContainer/TabContainer/Video/VBoxContainer/Fullscreen
@onready var vsync = $VBoxContainer/TabContainer/Video/VBoxContainer/VSync
@onready var mouse_sensitivity = $VBoxContainer/TabContainer/Controls/VBoxContainer/MouseSensitivity
@onready var stick_sensitivity = $VBoxContainer/TabContainer/Controls/VBoxContainer/StickSensitivity

signal close_menu

func _on_close_pressed():
	emit_signal("close_menu")

func _ready():
	fullscreen.set_default_value(game_data.fullscreen)
	vsync.set_default_value(game_data.vsync)
	mouse_sensitivity.set_default_value(game_data.mouse_sensitivity)
	stick_sensitivity.set_default_value(game_data.stick_sensitivity)

func _on_fullscreen_toggled(is_button_pressed: bool):
	game_data.fullscreen = is_button_pressed

func _on_vsync_toggled(is_button_pressed):
	game_data.vsync = is_button_pressed

func _on_mouse_sensitivity_value_changed(value):
	if not game_data:
		# not ready yet, this is only being set because of the default min value
		return

	game_data.mouse_sensitivity = value

func _on_stick_sensitivity_value_changed(value):
	if not game_data:
		# not ready yet, this is only being set because of the default min value
		return

	game_data.stick_sensitivity = value
