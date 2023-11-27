extends CharacterBody2D

@export var throw: Throw

enum State {
	IDLE,
	ROTATING,
	STOPPING
}

var charge: float
var is_charge_zero: float:
	get:
		return is_equal_approx(charge, 0)
var state := State.IDLE


func _ready():
	throw.charge_changed.connect(func(new_charge: float, _old: float): charge = new_charge)

func _physics_process(delta: float):
	match(state):
		State.IDLE:
			_process_idle(delta)
		State.ROTATING:
			_process_rotating(delta)
		State.STOPPING:
			_process_stopping(delta)

func _process_idle(delta: float):
	if not is_charge_zero:
		state = State.ROTATING

func _process_rotating(delta: float):
	if is_charge_zero:
		state = State.STOPPING
		return
	
	# TODO: Adjust rotation speed with min and max
	_adjust_scale_x(delta, charge)

func _process_stopping(delta: float):
	if is_charge_zero and is_equal_approx(skew, 0):
		state = State.IDLE
		return
	elif not is_charge_zero:
		state = State.ROTATING
		return
	
	_adjust_scale_x(delta, abs(scale.x) - .1)

var skew_direction := 1
var skew_speed := 1
func _adjust_scale_x(delta: float, value: float): 
	if scale.x == 0 or scale.x <= -1:
		skew_direction = 1
	elif scale.x >= 1:
		skew_direction = -1
	
	var increment = delta * value * skew_direction * skew_speed
	scale.x += increment
