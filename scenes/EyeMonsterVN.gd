extends Node2D

@onready var background_music = get_node("/root/BackgroundMusic")
@onready var game_data: GameData = get_node("/root/GameData")

var bgMusic = preload("res://assets/freesound/702660__kronek9__emanation.ogg")

func _ready():
	# start fading in
	$CanvasLayer/FadeInOut.visible = true
	$AnimationPlayer.play("fade_in")
	
	# bg music
	background_music.play(bgMusic)

func _process(_delta):
	pass

func start_dialog():
	Dialogic.timeline_ended.connect(_on_timeline_ended)
	Dialogic.start("res://dialogic/eyemonstervn_{vibe}.dtl".format({"vibe": game_data.current_vibe_i}))

func _on_timeline_ended():
	Dialogic.timeline_ended.disconnect(_on_timeline_ended)
	
	$AnimationPlayer.play("fade_out")

func fade_out_music():
	background_music.fade_out(3)

func next_scene():
	get_tree().change_scene_to_file("res://scenes/ExampleFirstPerson.tscn")
