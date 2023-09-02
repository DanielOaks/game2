extends Node

enum ControllerType {Gamepad, KeyboardMouse}

signal controller_type_changed(new_controller: ControllerType)

var current: ControllerType = ControllerType.KeyboardMouse

func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if current != ControllerType.Gamepad:
			# set to gamepad
			current = ControllerType.Gamepad
			controller_type_changed.emit(ControllerType.Gamepad)
	elif event is InputEventKey or event is InputEventMouse:
		if current != ControllerType.KeyboardMouse:
			# set to kb/m
			current = ControllerType.KeyboardMouse
			controller_type_changed.emit(ControllerType.KeyboardMouse)
