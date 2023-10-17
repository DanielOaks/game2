extends AnimatedSprite2D

@onready var initialSt = Time.get_ticks_msec()
@onready var eym_bg = $"../EymBg"

func _ready():
	play()

func get_xy(st: int):
	var newPos: Vector2 = Vector2.ZERO
	newPos.x = sin(st * .1 / 50 + .22) * 19.9
	newPos.y = cos(st * .035 / 76 + .3) * 13.9
	return newPos

func _process(_delta):
	# scene time
	var st: int = Time.get_ticks_msec() - initialSt

	position = get_xy(st)
	eym_bg.position = get_xy(st - 750)
