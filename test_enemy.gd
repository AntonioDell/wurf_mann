extends CharacterBody3D

func get_damage():
	queue_free()
	return 10

func _on_enemy_hurtbox_health_depleted():
	queue_free()

func _physics_process(delta):
	move_and_collide(Vector3.LEFT * 3 * delta)
