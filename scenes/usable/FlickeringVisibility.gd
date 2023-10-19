extends Node3D

## Controls how fast the flickering can be.
@export var multiply_time_by: float = 100

## The value that the random sample must hit to trigger. Lower values mean more time spent off!
@export var sample_must_be_over: float = 0.4

## If true, don't flicker when the vibe is bouncy!
@export var dont_flicker_when_optimistic: bool = true

@onready var game_data: GameData = get_node("/root/GameData")

var noise := NoiseTexture2D.new()
var time_passed: float = 0

func _ready():
	# random flickering each start
	var newFnl = FastNoiseLite.new()
	newFnl.seed = randi()
	
	noise.noise = newFnl

func _process(delta):
	time_passed += delta

	# check for optimism
	if dont_flicker_when_optimistic and game_data.current_vibe_i == 2:
		visible = true
		return
	
	# no optimism, sample for flickering
	var sample = abs(noise.noise.get_noise_1d(time_passed * multiply_time_by))
	
	if sample > sample_must_be_over:
		visible = false
	else:
		visible = true
