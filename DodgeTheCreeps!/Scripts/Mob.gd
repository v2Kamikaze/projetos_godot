extends RigidBody2D

export(int) var min_speed: int = 150
export(int) var max_speed: int = 250

func _ready():
	# pegando a lista de animações disponíveis para o mob.
	var mob_types = $MobAnimatedSprite.frames.get_animation_names()
	# escolhendo uma animação aleatoriamente.
	$MobAnimatedSprite.animation = mob_types[randi() % mob_types.size()]


func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # autodestruindo o nó.
