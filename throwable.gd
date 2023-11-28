extends CharacterBody3D


@export_category("Node dependencies")
@export var projectile_motion: ProjectileMotion
@export var throw: Throw


var is_released := false
@onready var initial_position := position


func get_damage():
	_reset()
	# TODO: Make damage variable somehow
	return 10

func _ready():
	throw.released.connect(_on_throw_released)
	throw.charge_input_registered.connect(_on_throw_charge_input_registered)
	
	projectile_motion.modifiers.modify_gravity = func(last_status): 
		if last_status.peak_reached and last_status.charge < .5:
			# TODO: Improve gravity increase with time passed
			return 20
		return 10
	projectile_motion.modifiers.velocity_multiplier = func(last_status): return Vector2(2, 1)

func _physics_process(delta: float):
	if not is_released:
		return
		
	var movement = projectile_motion.get_velocity(delta)
	var movement_3d = Vector3(movement.x, movement.y, position.z)
	# TODO: Add controllable velocity
	move_and_collide(movement_3d * delta)

func _on_throw_released(charge: float):
	is_released = true
	projectile_motion.start_new_motion(charge)

func _on_throw_charge_input_registered(input: int): 
	if input != 0 and is_released:
		_reset()

func _reset():
	is_released = false
	position = initial_position
