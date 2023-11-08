extends Node
class_name ChargeInput


signal charge_changed(charge: float)
signal input_registered(input: int)


const BASE_CHARGE_INCREASE = 0.1


@export var charge := 0.0:
	set(value):
		charge = clampf(value, 0, 1)
		charge_changed.emit(charge)
		if charge == 0:
			last_input = 0
			_reset_decrease_delay_timer()


var last_input := 0: 
	set(value):
		last_input = value
		input_registered.emit(value)
		
var next_charge_increase := 0.0
var time_since_last_press := 0.0
var decrease_factor := 0.0


func _on_decrease_delay_timer_timeout():
	decrease_factor = .25

func _reset_decrease_delay_timer():
	decrease_factor = 0
	%DecreaseDelayTimer.start()

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

func _get_charge_increase(time_since_last_press: float, optimal_press_time: float = 1.0):
	if time_since_last_press == -1:
		# No last press
		return BASE_CHARGE_INCREASE
	
	var timing_modificator = clampf(2 - abs(optimal_press_time - time_since_last_press), 0, 2)
	return BASE_CHARGE_INCREASE * timing_modificator


