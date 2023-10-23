extends Node3D

@onready var background_music = get_node("/root/BackgroundMusic")

@onready var stage = $stage

var bgMusic = preload("res://assets/game2/sound/ChillBgLoop.ogg")

func _ready():
	background_music.play(bgMusic)

func _process(delta):
	stage.rotate_y(.04 * delta)
