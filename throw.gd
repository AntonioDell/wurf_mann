extends Node
class_name Throw
## Handle charge and release for a throw.

signal charge_changed(new_charge: float, old_charge: float)
signal charge_input_registered(input: int)
signal released(charge: float)
signal is_release_possible_changed(is_possible: bool)


@export var base_charge_increase := 0.1


var charge := 0.0:
	set(value):
		var new_charge = clampf(value, 0, 1)
		charge_changed.emit(new_charge, charge)
		charge = new_charge
		is_release_possible = charge > 0
		if charge == 0:
			last_input = 0
			_reset_decrease_delay_timer()
var last_input := 0: 
	set(value):
		last_input = value
		charge_input_registered.emit(value)
var is_release_possible := false:
	set(value):
		if is_release_possible != value:
			is_release_possible = value
			is_release_possible_changed.emit(is_release_possible)
var next_charge_increase := 0.0
var time_since_last_press := 0.0
var decrease_factor := 0.0


func _unhandled_input(event):
	if Input.is_action_just_pressed("release_throw") and is_release_possible:
		released.emit(charge)
		charge = 0

func _process(delta):
	var input := Input.get_axis("increase_charge_left", "increase_charge_right")
	if input == 0 or input == last_input:
		time_since_last_press += delta
		# TODO: Change decrease factor based on charge
		charge -= delta * decrease_factor
		return
	
	# Input happened
	# TODO: Change optimal_press_time based on charge
	charge += _get_charge_increase(time_since_last_press)
	last_input = input
	time_since_last_press = 0
	_reset_decrease_delay_timer()

func _on_decrease_delay_timer_timeout():
	decrease_factor = .25

func _reset_decrease_delay_timer():
	decrease_factor = 0
	%DecreaseDelayTimer.start()

func _get_charge_increase(time_since_last_press: float, optimal_press_time: float = 1.0):
	if time_since_last_press == -1:
		# No last press
		return base_charge_increase
	
	var timing_modificator = clampf(2 - abs(optimal_press_time - time_since_last_press), 0, 2)
	return base_charge_increase * timing_modificator
