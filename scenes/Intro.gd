extends Node2D

@onready var game_data: GameData = get_node("/root/GameData")
@onready var bg_light_1 = $"StuffInScene/BG light 1"
@onready var objects_light_1 = $"StuffInScene/Objects light 1"
@onready var camera_2d = $StuffInScene/Camera2D
@onready var tile_map = $StuffInScene/TileMap

@onready var initialSt = Time.get_ticks_msec()

func _ready():
	# setup vibe portrait
	tile_map.set_cell(0, Vector2i(2,-2), 2, Vector2i(16 + game_data.current_vibe_i,10))
	# var tile_map_layer = 0 
	# var tile_map_cell_position = Vector2i(2,-2) 
	# print_debug(tile_map.get_cell_source_id(tile_map_layer, tile_map_cell_position))
	# print_debug(tile_map.get_cell_atlas_coords(tile_map_layer, tile_map_cell_position))
	# print_debug(tile_map.get_cell_alternative_tile(tile_map_layer, tile_map_cell_position))
	
	# start cutscene intro
	$CanvasLayer/FadeInOut.visible = true
	$AnimationPlayer.play("intro")
	camera_2d.position_smoothing_enabled = false

func _process(_delta):
	# scene time
	var st: int = Time.get_ticks_msec() - initialSt
	
	# fix camera position
	if st > 100 && camera_2d.position_smoothing_enabled == false:
		camera_2d.position_smoothing_enabled = true

	# light flickering
	var lightEnergy: float = sin(st * .01) + cos(st*.12-240)*.13 + sin((st+300)*.04)*.4 + cos(st*.007)*.5
	
	objects_light_1.energy = 7 + lightEnergy * 1.3
	objects_light_1.texture_scale = 1.0 + lightEnergy * 0.001
	bg_light_1.energy = 2.64 + lightEnergy * 0.1
	bg_light_1.texture_scale = 2.0 + lightEnergy * 0.01

func _on_animation_finished(anim_name):
	if anim_name == "intro":
		$StuffInScene/Player2DS.set_moving_allowed(true)
		$StuffInScene/Player2DS/RemoteTransform2D.update_position = true
	elif anim_name == "fade_out":
		print_debug("Transition to new scene")

func _on_fade_out_collider_body_entered(body):
	if body != $StuffInScene/Player2DS:
		return
	$AnimationPlayer.play("fade_out")
