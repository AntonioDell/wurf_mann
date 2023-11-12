extends Node
class_name ProjectileMotion
## See projectile motion: 
## https://en.wikipedia.org/wiki/Projectile_motion#Angle_%7F'%22%60UNIQ--postMath-0000003A-QINU%60%22'%7F_required_to_hit_coordinate_\(x,y\)

@export_category("Current motion")
@export var charge: float

@export_category("General config")
@export_range(0.0, 1.4) var release_angle_min = .6
@export_range(0.0, 1.4) var release_angle_max := 1.4
@export var angular_velocity_min = 8.0
@export var angular_velocity_max = 10.0
@export var gravity_baseline = 10

var last_velocity: Vector2
var time_since_release: float
var angular_velocity: float
var release_angle: float

## Start new projectile motion, resets internal state for [param new_charge].
func start_new_motion(new_charge: float):
	last_velocity = Vector2.ZERO
	time_since_release = 0
	charge = clampf(new_charge, 0.0, 1.0)
	angular_velocity = _get_angular_velocity()
	release_angle = _get_release_angle()

## Get velocity in x and y direction for current motion with time increase 
## [param delta].
func get_velocity(delta: float) -> Vector2:
	time_since_release += delta
	var gravity = _get_gravity()
	
	var x = angular_velocity * cos(release_angle)
	var y = (angular_velocity * sin(release_angle)) - (gravity * time_since_release)
	last_velocity = Vector2(x,y)
	return last_velocity

func _get_angular_velocity() -> float:
	var angular_velocity = lerpf(angular_velocity_min, angular_velocity_max, charge)
	return angular_velocity

func _get_release_angle() -> float:
	var release_angle = lerpf(release_angle_max, release_angle_min, charge)
	return release_angle

func _get_gravity() -> float:
	return gravity_baseline
