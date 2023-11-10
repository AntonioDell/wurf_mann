extends Node
class_name ProjectileMotion

@export_range(0.0, 1.4) var release_angle_min = .6
@export_range(0.0, 1.4) var release_angle_max := 1.4

@export var angular_velocity_min = 8.0
@export var angular_velocity_max = 10.0

const GRAVITY = 10

# See projectile motion 
# https://en.wikipedia.org/wiki/Projectile_motion#Angle_%7F'%22%60UNIQ--postMath-0000003A-QINU%60%22'%7F_required_to_hit_coordinate_\(x,y\)

func calculate_displacement(time_since_release: float, charge: float) -> Vector2:
	var charge_clamped = clampf(charge, 0.0, 1.0)
	var angular_velocity = _get_angular_velocity(charge_clamped)
	var release_angle = _get_release_angle(charge_clamped)
	
	var x = angular_velocity * time_since_release * cos(release_angle)
	var y = -angular_velocity * time_since_release * sin(release_angle) + (.5 * GRAVITY * pow(time_since_release, 2))
	return Vector2(x, y)

func calculate_velocity(time_since_release: float, charge: float) -> Vector2:
	var charge_clamped = clampf(charge, 0.0, 1.0)
	var angular_velocity = _get_angular_velocity(charge_clamped)
	var release_angle = _get_release_angle(charge_clamped)
	
	var x = angular_velocity * cos(release_angle)
	var y = (angular_velocity * sin(release_angle)) - (GRAVITY * time_since_release)
	return Vector2(x,y)

func _get_angular_velocity(charge: float) -> float:
	var angular_velocity = lerpf(angular_velocity_min, angular_velocity_max, charge)
	return angular_velocity

func _get_release_angle(charge: float) -> float:
	var release_angle = lerpf(release_angle_max, release_angle_min, charge)
	return release_angle
