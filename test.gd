extends Node


const SIMULATION_RESOLUTION = .1


@onready var simulation: ProjectileMotion = $ProjectileMotion
@onready var charge_input: ChargeInput = $ChargeInput
@onready var visualizer: Visualizer = $Visualizer


func _on_charge_input_charge_changed(charge, _old):
	%ChargeVisualizer.value = charge

func _on_release_input_is_release_possible_changed(is_possible):
	%ReleaseVisualizer.disabled = not is_possible

func _on_charge_input_input_registered(input):
	var next_input = "<>"
	if input > 0:
		next_input = "<"
	elif input < 0:
		next_input =  ">" 
	%NextInputVisualizer.text = "Next: %s" % next_input
