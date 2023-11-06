extends Sprite3D

@onready var parent := get_parent_node_3d()
var half_pi = snapped(.5*PI, 0.1)

func _process(delta):
	var parent_rotation_y = snapped(parent.rotation.abs().y, 0.1)
	if is_equal_approx(parent_rotation_y,half_pi):
		visible = false
	elif not visible:
		visible = true
