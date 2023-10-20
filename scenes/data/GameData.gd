# stores both live game data and settings that are stored in the config.
# we do this in two separate sections, to make things easier to read
extends Node

## shared

func _ready():
	# settings
	var err = _config.load(_config_path)
	if err != OK:
		# file didn't load, so ignore
		return
	
	set_window_mode(fullscreen)
	set_vsync_mode(vsync)
	set_volume("Master", game_volume)
	set_volume("UI", ui_volume)
	set_volume("BG", bg_volume)
	
	# live game data
	update_colours()

func _process(_delta):
	if _vibe_locked: return

	if Input.is_action_just_pressed("next_vibe"):
		next_vibe()
	if Input.is_action_just_pressed("previous_vibe"):
		prev_vibe()

## settings

const _config_path = "user://settings.cfg"
var _config := ConfigFile.new()

var fullscreen: bool :
	get:
		return _config.get_value("video", "fullscreen", false)
	set(value):
		_config.set_value("video", "fullscreen", value)
		_config.save(_config_path)
		set_window_mode(value)
		fullscreen = value

func set_window_mode(set_fullscreen: bool):
	if set_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

var vsync: bool :
	get:
		return _config.get_value("video", "vsync", false)
	set(value):
		_config.set_value("video", "vsync", value)
		_config.save(_config_path)
		set_vsync_mode(value)
		vsync = value

func set_vsync_mode(enable: bool):
	if enable:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

signal fog_type_updated
enum FogType {HQ = 2, NORMAL = 1, LQ = 0}

var fog_type: FogType :
	get:
		return _config.get_value("video", "fog_type", FogType.HQ)
	set(value):
		_config.set_value("video", "fog_type", value)
		_config.save(_config_path)
		emit_signal("fog_type_updated", value)

var game_volume: float :
	get:
		return _config.get_value("audio", "volume", 100.0)
	set(value):
		_config.set_value("audio", "volume", value)
		_config.save(_config_path)
		set_volume("Master", value)
		game_volume = value

var ui_volume: float :
	get:
		return _config.get_value("audio", "ui_volume", 100.0)
	set(value):
		_config.set_value("audio", "ui_volume", value)
		_config.save(_config_path)
		set_volume("UI", value)
		ui_volume = value

var bg_volume: float :
	get:
		return _config.get_value("audio", "bg_volume", 100.0)
	set(value):
		_config.set_value("audio", "bg_volume", value)
		_config.save(_config_path)
		set_volume("BG", value)
		bg_volume = value

## Set the volume of the given bus, with `value` being from 0 to 100.
func set_volume(bus_name: String, value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), linear_to_db(value / 100.0))

var mouse_sensitivity: float :
	get:
		return _config.get_value("control", "mouse_sensitivity", 0.2)
	set(value):
		_config.set_value("control", "mouse_sensitivity", value)
		_config.save(_config_path)
		mouse_sensitivity = value

var stick_sensitivity: float :
	get:
		return _config.get_value("control", "stick_sensitivity", 125)
	set(value):
		_config.set_value("control", "stick_sensitivity", value)
		_config.save(_config_path)
		stick_sensitivity = value

## live game data

signal vibe_changed(new_vibe: Vibe)

const VIBES: Array[Vibe] = [
	preload("res://assets/game2/vibes/red.tres"),
	preload("res://assets/game2/vibes/cool.tres"),
	preload("res://assets/game2/vibes/kawaii.tres"),
	preload("res://assets/game2/vibes/warm_ice.tres"),
]

var paletteImage: Image = preload("res://assets/game2/red-hood-character-palettes.png").get_image()

var cloak_base_colour: Color
var shorts_base_colour: Color
var skin_base_colour: Color
var hair_base_colour: Color

var _vibe_locked: bool = false
var current_vibe_i: int = 1
var current_vibe: Vibe = VIBES[current_vibe_i]

signal vibe_lock_changed(now_locked: bool)

# locking the vibe prevents the next/prev buttons from changing the vibe
func lock_vibe():
	_vibe_locked = true
	emit_signal("vibe_lock_changed", true)

# unlocking the vibe means it can be freely changed
func unlock_vibe():
	_vibe_locked = false
	emit_signal("vibe_lock_changed", false)

func set_vibe_to(new_vibe: int):
	current_vibe_i = new_vibe
	change_vibe()

func next_vibe():
	current_vibe_i += 1
	if current_vibe_i >= len(VIBES):
		current_vibe_i = 0
	change_vibe()

func prev_vibe():
	current_vibe_i -= 1
	if current_vibe_i < 0:
		current_vibe_i = len(VIBES) - 1
	change_vibe()

func change_vibe():
	update_colours()
	current_vibe = VIBES[current_vibe_i]
	vibe_changed.emit(current_vibe)

func update_colours():
	cloak_base_colour = paletteImage.get_pixel(2, current_vibe_i)
	shorts_base_colour = paletteImage.get_pixel(9, current_vibe_i)
	skin_base_colour = paletteImage.get_pixel(13, current_vibe_i)
	hair_base_colour = paletteImage.get_pixel(15, current_vibe_i)
