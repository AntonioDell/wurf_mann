extends Node3D

@onready var body: RigidBody3D = $RigidBody3D

func _ready():
	body.apply_torque_impulse(Vector3(0, 1, 0))

