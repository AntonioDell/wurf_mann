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
}


var last_charge := 0.0
var last_time_since_release := 0.0
var last_peak_reached := false
var last_velocity := Vector2.INF
var last_angular_velocity := INF
var last_gravity := INF
var last_release_angle := INF


## Start new projectile motion, resets internal state for [param new_charge].
func start_new_motion(charge: float):
	last_charge = clampf(charge, 0.0, 1.0)
	last_time_since_release = 0.0
	last_peak_reached = false
	last_angular_velocity = INF
	last_release_angle = INF
	last_gravity = INF
	
## Get velocity in x and y direction for current motion with time increase 
## [param delta].
func get_velocity(delta: float) -> Vector2:
	var last_status = {
		charge = last_charge,
		time_since_release = last_time_since_release,
		peak_reached = last_peak_reached,
		angular_velocity = last_angular_velocity,
		gravity = last_gravity,
		release_angle = last_release_angle
	}
	
	last_time_since_release += delta
	last_gravity = (modifiers.modify_gravity as Callable).call(last_status)
	last_angular_velocity = (modifiers.modify_angular_velocity as Callable).call(last_status)
	last_release_angle = (modifiers.modify_release_angle as Callable).call(last_status)
	
	var x = last_angular_velocity * cos(last_release_angle)
	var y = (last_angular_velocity * sin(last_release_angle)) - (last_gravity * last_time_since_release)
	
	var new_velocity = Vector2(x,y)
	if not last_peak_reached and last_velocity != Vector2.INF and sign(last_velocity.y) > sign(new_velocity.y) :
		last_peak_reached = true
	last_velocity = new_velocity
	
	return last_velocity


