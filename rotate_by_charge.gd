extends RigidBody3D
class_name RotateByCharge

@export var charge_input: ChargeInput

var current_charge: float
func _ready():
	charge_input.charge_changed.connect(func(new_charge: float): current_charge = new_charge)
	charge_input.input_registered.connect(_on_input_registered)


func _on_input_registered(input: int):
	# TODO: Tweak max angular_velocity and torque impulse -> Create utility
	if angular_velocity.y <= 10:
		apply_torque_impulse(Vector3(0, 1, 0) * current_charge)
	# TODO: Make sure to always end the rotation in the right facing direction
