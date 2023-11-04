extends Node

@onready var simulation: HammerThrowSimulation = $HammerThrowSimulation
@onready var visualizer: Visualizer = $Visualizer

var time_to_simulate: float = 1.0
var angular_velocity: float = 0.0
var release_angle: float = 0.0

const SIMULATION_RESOLUTION = .1

func on_simulation_value_changed():
	visualizer.reset()
	var i = 0
	while i < time_to_simulate:
		var new_point = simulation.calculate_position(i, angular_velocity)
		visualizer.add_point(new_point)
		i += SIMULATION_RESOLUTION


func _on_time_to_simulate_value_changed(value):
	time_to_simulate = value
	on_simulation_value_changed()

func _on_angular_velocity_value_changed(value):
	angular_velocity = value
	on_simulation_value_changed()

func _on_release_angle_value_changed(value):
	release_angle = value
	on_simulation_value_changed()
