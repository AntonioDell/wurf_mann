extends Node
class_name HammerThrowSimulation

@export_range(0.0, 1.4) var release_angle_min = .4
@export_range(0.0, 1.4) var release_angle_max := 1.2

const GRAVITY = 10
const ANGULAR_VELOCITY_MULTIPLIER = 100.0

# TODO: Angular velocity cannot be taken directly as input
# We need a value determined by the player between 0.0 and 1.0
# From that we need to derive the angular velocity and the release angle
# Such that the arc is high enough for low input values
func calculate_position(time_since_release: float, angular_velocity: float) -> Vector2:
	var v = clampf(angular_velocity, 0.0, 1.0)
	var release_angle = _calculate_release_angle(v)
	var x = (v * ANGULAR_VELOCITY_MULTIPLIER) * time_since_release * cos(release_angle)
	var y = -(v * ANGULAR_VELOCITY_MULTIPLIER) * time_since_release * sin(release_angle) + (.5 * GRAVITY * pow(time_since_release, 2))
	var pos = Vector2(x, y)
	return pos


func _calculate_release_angle(angular_velocity: float) -> float:
	var release_angle
	if angular_velocity <= .3:
		release_angle = remap(angular_velocity, 0.0, 0.3, release_angle_min, release_angle_max )	
	elif angular_velocity < .7:
		release_angle = remap(angular_velocity, 0.3, 0.7, release_angle_max, release_angle_max - release_angle_min )
	else:
		release_angle = remap(angular_velocity, 0.7, 1.0, release_angle_max - release_angle_min, release_angle_min )
	print(release_angle)
	return release_angle
