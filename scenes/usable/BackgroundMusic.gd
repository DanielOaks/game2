extends Node

@onready var player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animator = $AnimationPlayer

func _ready():
	pass

func _process(_delta):
	pass

func play(sound: AudioStream):
	# check if we are already playing this
	if player.stream == sound and player.playing:
		return
	
	# reset everything back to stock
	player.stop()
	animator.play("reset")
	
	# start the new track
	player.stream = sound
	player.play()

func fade_out(seconds: float):
	animator.speed_scale = 1 / seconds
	animator.play("fade_out")
