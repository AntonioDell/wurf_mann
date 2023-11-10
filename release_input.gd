extends Node
class_name ReleaseInput


signal release_input()
signal is_release_possible_changed(is_possible: bool)


@export var charge_input: ChargeInput

var is_release_possible := false:
	set(value):
		is_release_possible = value
		is_release_possible_changed.emit(is_release_possible)


func _ready():
	charge_input.charge_changed.connect(_on_charge_input_charge_changed)

func _on_charge_input_charge_changed(charge: float, _old: float):
	is_release_possible = charge > 0

func _unhandled_input(event):
	if Input.is_action_just_pressed("release_throw") and is_release_possible:
		release_input.emit()
