extends CharacterBody3D
class_name RotateByCharge


@export var charge_input: ChargeInput

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
	charge_input.charge_changed.connect(func(new_charge: float, _old: float): charge = new_charge)

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
	rotate_y(delta * charge * 2 * PI * 5)

func _process_stopping(delta: float):
	if is_charge_zero and is_equal_approx(rotation.y, 0):
		state = State.IDLE
		return
	elif not is_charge_zero:
		state = State.ROTATING
		return
	
	# FIXME: This will stop the rotation abruptly (adding * delta doesn't work)
	var rot = (2 * PI) - rotation.y
	rotate_y(rot)
