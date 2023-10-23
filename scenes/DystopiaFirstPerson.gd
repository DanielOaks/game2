extends Node3D

@onready var background_music = get_node("/root/BackgroundMusic")
@onready var game_data: GameData = get_node("/root/GameData")
@onready var world_environment = $env/WorldEnvironment

@onready var afraid_text: ShowableNode3D = $NavigationRegion3D/stage/AfraidText
@onready var afraid_text_2_hasleft = $"NavigationRegion3D/stage/AfraidText2-hasleft"
@onready var afraid_text_2_neverleft = $"NavigationRegion3D/stage/AfraidText2-neverleft"

var player_in_spawn := true
var player_has_left_spawn := false
var total_player_time_in_spawn: float = 0

var bgMusic = preload("res://assets/game2/sound/DystopianBgLoop.ogg")

func _ready():
	set_fog_type(game_data.fog_type)
	$AnimationPlayer.play("fade_in")
	background_music.play(bgMusic)

func _physics_process(delta):
	if player_in_spawn:
		total_player_time_in_spawn += delta

func _process(_delta):
	# spawn text
	if player_in_spawn:
		if total_player_time_in_spawn >= 17 and total_player_time_in_spawn < 18 and not afraid_text.currently_showing():
			afraid_text.show_item()
		elif total_player_time_in_spawn >= 26 and total_player_time_in_spawn < 27:
			if player_has_left_spawn and not afraid_text_2_hasleft.currently_showing():
				afraid_text_2_hasleft.show_item()
			elif (not player_has_left_spawn) and not afraid_text_2_neverleft.currently_showing():
				afraid_text_2_neverleft.show_item()

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

func _on_spawn_area_body_entered(body):
	if body != $Player:
		return

	player_in_spawn = true

func _on_spawn_area_body_exited(body):
	if body != $Player:
		return
		
	player_in_spawn = false
	player_has_left_spawn = true

func _on_player_body_entered(body):
	if body != $AlertBot:
		return

	$AnimationPlayer.play("die")

func move_to_die_scene():
	get_tree().change_scene_to_file("res://scenes/CloudyFirstPerson.tscn")

func fade_out_bg_music(seconds: float):
	background_music.fade_out(seconds)

func _on_exit_area_body_entered(body):
	if body != $Player:
		return

	if randf() >= 0.5:
		get_tree().change_scene_to_file("res://scenes/EuropeanPlumberSiblingSideScroll.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ExampleSideScroll.tscn")
