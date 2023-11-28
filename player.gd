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
	
	_adjust_scale_x(delta, charge)

# TODO: Adjust stopping behavior
# Currently multiple rotations can occur when it should have stopped already
func _process_stopping(delta: float):
	if is_charge_zero and scale.x >= 1:
		scale.x = 1
		state = State.IDLE
		return
	elif not is_charge_zero:
		state = State.ROTATING
		return
	
	# TODO: Replace .2 with gradually slowing value which always stops rotation after the same time
	# regardless what scale.x value currently  is, before state is stopped.
	_adjust_scale_x(delta, .2)

var scale_direction := 1
var scale_speed := 1
func _adjust_scale_x(delta: float, value: float): 
	if scale.x >= 1:
		scale_direction = -1
	elif scale.x <= -1:
		scale_direction = 1
	
	var increment = delta * _get_scale_velocity(value) * scale_direction * scale_speed
	scale.x += increment

var min_velocity := 1.0
var max_velocity := 10.0
func _get_scale_velocity(value: float) -> float:
	return lerpf(min_velocity, max_velocity, ease(value, 3.0))
