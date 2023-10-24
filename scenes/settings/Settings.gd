extends Panel

@onready var game_data: GameData = get_node("/root/GameData")
@onready var fullscreen = $VBoxContainer/TabContainer/Video/VBoxContainer/Fullscreen
@onready var vsync = $VBoxContainer/TabContainer/Video/VBoxContainer/VSync
@onready var fog = $VBoxContainer/TabContainer/Video/VBoxContainer/Fog
@onready var main_volume = $VBoxContainer/TabContainer/Audio/VBoxContainer/MainVolume
@onready var ui_volume = $VBoxContainer/TabContainer/Audio/VBoxContainer/UIVolume
@onready var bg_volume = $VBoxContainer/TabContainer/Audio/VBoxContainer/BGVolume
@onready var mouse_sensitivity = $VBoxContainer/TabContainer/Controls/VBoxContainer/MouseSensitivity
@onready var stick_sensitivity = $VBoxContainer/TabContainer/Controls/VBoxContainer/StickSensitivity
@onready var show_test_buttons = $VBoxContainer/TabContainer/Controls/VBoxContainer/ShowTestButtons

signal close_menu

func _on_close_pressed():
	emit_signal("close_menu")

func _ready():
	fullscreen.set_default_value(game_data.fullscreen)
	vsync.set_default_value(game_data.vsync)
	fog.set_default_value(game_data.fog_type)
	
	main_volume.set_default_value(game_data.game_volume)
	ui_volume.set_default_value(game_data.ui_volume)
	bg_volume.set_default_value(game_data.bg_volume)
	
	mouse_sensitivity.set_default_value(game_data.mouse_sensitivity)
	stick_sensitivity.set_default_value(game_data.stick_sensitivity)

	show_test_buttons.set_default_value(game_data.show_test_buttons)

# video

func _on_fullscreen_toggled(is_button_pressed: bool):
	game_data.fullscreen = is_button_pressed

func _on_vsync_toggled(is_button_pressed):
	game_data.vsync = is_button_pressed

func _on_fog_item_selected(index, _text):
	game_data.fog_type = index

# Audio

func _on_main_volume_value_changed(value):
	game_data.game_volume = value

func _on_ui_volume_value_changed(value):
	game_data.ui_volume = value

func _on_bg_volume_value_changed(value):
	game_data.bg_volume = value

# Controls

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

func _on_show_test_buttons_toggled(is_button_pressed):
	game_data.show_test_buttons = is_button_pressed
