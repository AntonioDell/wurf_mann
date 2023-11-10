extends CharacterBody3D


@export_category("Node dependencies")
@export var projectile_motion: ProjectileMotion
@export var charge_input: ChargeInput
@export var release_input: ReleaseInput

var release_charge: float
var is_released := false
var time_since_throw_start := 0.0

@onready var initial_position := position

func _ready():
	charge_input.charge_changed.connect(_on_charge_changed)
	charge_input.input_registered.connect(_on_input_registered)
	release_input.release_input.connect(_on_release_input)

func _physics_process(delta):
	if not is_released:
		time_since_throw_start = 0
		return
		
	var movement = projectile_motion.calculate_velocity(time_since_throw_start, release_charge)
	var movement_3d = Vector3(movement.x * 2, movement.y, position.z)
	time_since_throw_start += delta
	# TODO: Add controllable velocity
	move_and_collide(movement_3d * delta)

func _on_charge_changed(new_charge: float, old_charge: float):
	if new_charge == 0 and old_charge > 0:
		release_charge = old_charge

func _on_release_input():
	is_released = true

func _on_input_registered(input: int): 
	if input != 0 and is_released:
		print("Reset")
		reset()

func reset():
	is_released = false
	position = initial_position
