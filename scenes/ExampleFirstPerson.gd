extends Node3D

@onready var game_data: GameData = get_node("/root/GameData")
@onready var world_environment = $env/WorldEnvironment

func _ready():
	set_fog_type(game_data.fog_type)

func set_fog_type(value: int):
	var env: Environment = world_environment.environment

	if value == 2: # hq
		env.volumetric_fog_enabled = true
		env.fog_enabled = true
		env.fog_density = 0.01
	elif value == 1: # normal
		env.volumetric_fog_enabled = false
		env.fog_enabled = true
		env.fog_density = 0.05
	elif value == 0: # lq
		env.volumetric_fog_enabled = false
		env.fog_enabled = false
	else: # ???
		print_debug("Unknown fog type: ", value)
