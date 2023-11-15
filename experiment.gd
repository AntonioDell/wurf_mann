extends Node


@onready var throw: Throw = $Throw


func _ready():
	throw.charge_changed.connect(_on_throw_charge_changed)
	throw.charge_input_registered.connect(_on_throw_charge_input_registered)
	throw.is_release_possible_changed.connect(_on_throw_is_release_possible_changed)

func _on_throw_charge_changed(charge, _old):
	%ChargeVisualizer.value = charge

func _on_throw_charge_input_registered(input):
	var next_input = "<>"
	if input > 0:
		next_input = "<"
	elif input < 0:
		next_input =  ">" 
	%NextInputVisualizer.text = "Next: %s" % next_input

func _on_throw_is_release_possible_changed(is_possible):
	%ReleaseVisualizer.disabled = not is_possible
