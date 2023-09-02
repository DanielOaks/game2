extends Node

var mouse_sensitivity: float = 0.2

signal vibe_changed(new_vibe: Vibe)

const VIBES: Array[Vibe] = [
	preload("res://assets/game2/vibes/red.tres"),
	preload("res://assets/game2/vibes/cool.tres"),
	preload("res://assets/game2/vibes/kawaii.tres"),
	preload("res://assets/game2/vibes/warm_ice.tres"),
]

var current_vibe_i: int = 0
var current_vibe: Vibe = VIBES[current_vibe_i]

# temp, for now
func _process(_delta):
	if Input.is_action_just_pressed("next_vibe"):
		next_vibe()
	if Input.is_action_just_pressed("previous_vibe"):
		prev_vibe()

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
	current_vibe = VIBES[current_vibe_i]
	vibe_changed.emit(current_vibe)
