extends HBoxContainer

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
