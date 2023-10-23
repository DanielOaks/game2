extends Node3D

@onready var game_data: GameData = get_node("/root/GameData")

@onready var current_platform = $platforms/CurrentPlatform
@onready var current_platform_material: StandardMaterial3D = $platforms/CurrentPlatform/Cylinder.get_active_material(0)

@onready var next_platform = $platforms/NextPlatform
@onready var next_platform_material: StandardMaterial3D = $platforms/NextPlatform/Cylinder.get_active_material(0)

var times_dropped_down: int = 0

# see https://github.com/godotengine/godot-proposals/issues/1731
# maybe this can be done nicer in the future :pray: :hands-raised:
func new_direction() -> Vector2:
	var new_dir: = Vector2()
	new_dir.x = randf_range(-1, 1)
	new_dir.y = randf_range(-1, 1)
	return new_dir.normalized()

func _ready():
	current_platform_material.albedo_color = Color.from_hsv(randf(), .5, .7)
	next_platform_material.albedo_color = Color.from_hsv(randf(), .5, .7)
	
	times_dropped_down = 0

func _process(_delta):
	if game_data.should_reset_game():
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_next_platform_body_entered(body):
	if body != $Player:
		return
	
	place_next_platform()

func place_next_platform():
	current_platform.position = next_platform.position
	current_platform_material.albedo_color = next_platform_material.albedo_color

	# generate new colour
	next_platform_material.albedo_color = Color.from_hsv(randf(), .5, .7)
	
	# move down
	next_platform.position.y -= 5
	
	# move to new spot
	var new_dir := new_direction()
	next_platform.position.x += new_dir.x * 12
	next_platform.position.z += new_dir.y * 12
	
	# update counter
	times_dropped_down += 1
	$UI/TimesDroppedDown.text = str(times_dropped_down)
