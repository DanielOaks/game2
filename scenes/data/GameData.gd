extends Node

var mouse_sensitivity: float = 0.2
var stick_sensitivity: float = 125

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
var current_vibe_i: int = 0
var current_vibe: Vibe = VIBES[current_vibe_i]

func _ready():
	update_colours()

# temp, for now
func _process(_delta):
	if _vibe_locked: return

	if Input.is_action_just_pressed("next_vibe"):
		next_vibe()
	if Input.is_action_just_pressed("previous_vibe"):
		prev_vibe()

# locking the vibe prevents the next/prev buttons from changing the vibe
func lock_vibe():
	_vibe_locked = true

# unlocking the vibe means it can be freely changed
func unlock_vibe():
	_vibe_locked = false

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
