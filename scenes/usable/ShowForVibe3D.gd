extends Node3D

@onready var game_data: GameData = get_node("/root/GameData")

## Vibes to show for.
@export var vibes: Array[Vibe]

func _ready():
	game_data.connect("vibe_changed", update_vibe)
	update_vibe(game_data.current_vibe)

func update_vibe(new_vibe: Vibe):
	for vibe in vibes:
		if new_vibe.name == vibe.name:
			visible = true
			return
	visible = false
