extends Node

@onready var simulation: HammerThrowSimulation = $HammerThrowSimulation
@onready var charge_input: ChargeInput = $ChargeInput
@onready var visualizer: Visualizer = $Visualizer

var time_to_simulate: float = 5.0
var charge: float = 0.0
var release_angle: float = 0.0

const SIMULATION_RESOLUTION = .1


func _on_release_input_release_input():
	# TODO: Start hammer throw simulation
	charge_input.charge = 0

func on_simulation_value_changed():
	visualizer.reset()
	var i = 0
	while i < time_to_simulate:
		var new_point = simulation.calculate_position(i, charge)
		visualizer.add_point(new_point)
		i += SIMULATION_RESOLUTION

func _on_time_to_simulate_value_changed(value):
	time_to_simulate = value
	on_simulation_value_changed()

func _on_angular_velocity_value_changed(value):
	charge = value
	on_simulation_value_changed()

func _on_charge_input_charge_changed(charge):
	%ChargeVisualizer.value = charge

func _on_charge_input_valid_input_changed(input):
	var next_input = "<>"
	if input > 0:
		next_input = ">"
	elif input < 0:
		next_input =  "<" 
	%NextInputVisualizer.text = "Next: %s" % next_input


func _on_release_input_is_release_possible_changed(is_possible):
	%ReleaseVisualizer.disabled = not is_possible
