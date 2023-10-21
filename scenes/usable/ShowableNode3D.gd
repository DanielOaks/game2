extends Node3D
class_name ShowableNode3D

## Only show this item once.
@export var oneshot: bool = false

var already_shown: bool = false

## How long to show this item for, in seconds.
@export var shown_for_seconds: float = 3.5
var shown_for_ms :
	get:
		return shown_for_seconds * 1000

var last_shown_at: float = 0

func _ready():
	# reset last_shown_at to a time that means we definitely won't be showing it
	last_shown_at = Time.get_ticks_msec() - shown_for_seconds * 2000

func _process(_delta):
	visible = false
	if currently_showing():
		visible = true

func show_item():
	if oneshot and already_shown:
		return

	already_shown = true
	last_shown_at = Time.get_ticks_msec()

func currently_showing() -> bool:
	var st = Time.get_ticks_msec()
	return last_shown_at + shown_for_ms >= st
