@tool
extends HBoxContainer

@onready var label = $Label
@onready var slider = $HSlider
@onready var show_value = $ShowValue

# set default
func set_default_value(value):
	slider.value = value
	show_value.text = str(value)

# pass through the slider value
signal value_changed(value)

func _on_value_changed(value):
	emit_signal("value_changed", value)
	show_value.text = str(value)

# pass through title
@export var title := "" :
	get:
		return title

	set (value):
		# Wait until the scene is ready if `label` is null.
		if not label:
			await ready

		label.text = value
		title = value

@export var min_value: float :
	get:
		return min_value
	set(value):
		if not slider:
			await ready
		slider.min_value = value
		min_value = value

@export var max_value: float :
	get:
		return max_value
	set(value):
		if not slider:
			await ready
		slider.max_value = value
		max_value = value

@export var step: float :
	get:
		return step
	set(value):
		if not slider:
			await ready
		slider.step = value
		step = value

@export var rounded: bool :
	get:
		return rounded
	set(value):
		if not slider:
			await ready
		slider.rounded = value
		rounded = value
