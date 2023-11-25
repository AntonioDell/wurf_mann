extends Node
class_name ProjectileMotion
## See projectile motion: 
## https://en.wikipedia.org/wiki/Projectile_motion#Angle_%7F'%22%60UNIQ--postMath-0000003A-QINU%60%22'%7F_required_to_hit_coordinate_\(x,y\)


@export_category("Default modifier config")
@export_range(0.0, 1.4) var release_angle_min = .6
@export_range(0.0, 1.4) var release_angle_max := 1.4
@export var angular_velocity_min = 8.0
@export var angular_velocity_max = 10.0
@export var gravity_baseline = 10


## Keys: modify_angular_velocity, modify_gravity, modify_release_angle
## Values: Callables of form (last_status: { 
##   charge: float,
##   angular_velocity: float, 
##   gravity: float, 
##   release_angle: float, 
##   time_since_release: float,
##   change_in_velocity: Vector2 }) -> float
## Each callable must be able to handle NaN values for entries in last_status 
var modifiers: Dictionary = {
	modify_angular_velocity = func(last_status): return lerpf(angular_velocity_min, angular_velocity_max, last_status.charge),
	modify_gravity = func(last_status): return gravity_baseline,
	modify_release_angle = func(last_status): return lerpf(release_angle_max, release_angle_min, last_status.charge),
	velocity_multiplier = func(last_status): return Vector2.ONE
}


var charge := 0.0
var time_since_release := 0.0
var peak_reached := false
var velocity := Vector2.INF
var angular_velocity := INF
var gravity := INF
var release_angle := INF


## Start new projectile motion, resets internal state for [param new_charge].
func start_new_motion(new_charge: float):
	charge = clampf(new_charge, 0.0, 1.0)
	time_since_release = 0.0
	peak_reached = false
	angular_velocity = INF
	release_angle = INF
	gravity = INF


## Get velocity in x and y direction for current motion with time increase 
## [param delta].
func get_velocity(delta: float) -> Vector2:
	var last_status = {
		charge = charge,
		time_since_release = time_since_release,
		peak_reached = peak_reached,
		angular_velocity = angular_velocity,
		gravity = gravity,
		release_angle = release_angle
	}
	
	time_since_release += delta
	gravity = (modifiers.modify_gravity as Callable).call(last_status)
	angular_velocity = (modifiers.modify_angular_velocity as Callable).call(last_status)
	release_angle = (modifiers.modify_release_angle as Callable).call(last_status)
	
	var x = angular_velocity * cos(release_angle)
	var y = (angular_velocity * sin(release_angle)) - (gravity * time_since_release)
	
	var new_velocity: Vector2 = Vector2(x,y) * (modifiers.velocity_multiplier as Callable).call(last_status)
	if not peak_reached and velocity != Vector2.INF and sign(velocity.y) > sign(new_velocity.y) :
		peak_reached = true
	velocity = new_velocity
	
	return velocity


