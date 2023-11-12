extends Area3D
class_name Hurtbox


signal health_changed(new_health: int, old_health: int)
signal health_depleted()


@export var max_health: int = 100
@export var health: int = 100:
	set(value):
		var new_health = clampi(value, 0, max_health)
		if new_health == health:
			return
		
		health_changed.emit(new_health, health)
		if new_health == 0:
			health_depleted.emit()
		health = new_health


func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D):
	if body.has_method("get_damage"):
		var base_damage = body.get_damage()
		health -= base_damage


# TODO: Remove this debug code
func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		health -= 10
