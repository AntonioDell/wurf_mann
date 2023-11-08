extends Node


const SIMULATION_RESOLUTION = .1


@onready var simulation: ProjectileMotion = $ProjectileMotion
@onready var charge_input: ChargeInput = $ChargeInput
@onready var visualizer: Visualizer = $Visualizer
@onready var hammer: CharacterBody3D = %Hammer
@onready var hammer_initial_position := hammer.position

var reset_simulation := false
var released_charge: float = 0.0
var time_since_simulation_started: float = 0.0


func _process(delta):
	if reset_simulation:
		time_since_simulation_started = 0.0
		visualizer.reset()
		hammer.position = hammer_initial_position
		reset_simulation = false
	if released_charge == 0:
		return
		
	var movement = simulation.calculate_velocity(time_since_simulation_started, released_charge)
	var movement_3d = Vector3(movement.x, movement.y, hammer.position.z)
	time_since_simulation_started += delta
	hammer.move_and_collide(movement_3d*delta)
	# TODO: Don't simulate into infinity

func _on_release_input_release_input():
	released_charge = charge_input.charge
	charge_input.charge = 0
	reset_simulation = true

func _on_charge_input_charge_changed(charge):
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
