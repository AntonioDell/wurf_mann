extends ProgressBar

@export var hurtbox: Hurtbox

func _ready():
	max_value = hurtbox.max_health
	value = hurtbox.health
	hurtbox.health_changed.connect(func(health: int, _old_health: int): value = health)

