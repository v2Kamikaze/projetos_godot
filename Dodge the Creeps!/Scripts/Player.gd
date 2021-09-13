extends Area2D

signal hit

export(int) var speed: int = 400
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	self.position = Vector2(screen_size.x / 2, screen_size.y / 2)

func _process(delta) -> void:
	move_player(delta)

func move_player(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	# normalizando o vetor apenas se ele tiver comprimento maior que 0.
	if velocity.length() > 0: 
		velocity = velocity.normalized() * speed
		$PlayerAnimatedSprite.play()
	else:
		$PlayerAnimatedSprite.stop()
	
	# selecionando qual animação irá ser usada para a movimentação.
	_select_animation(velocity)
	
	self.position +=  velocity * delta
	# mantendo a posição do jogador entre os limites da tela.
	self.position.x = clamp(self.position.x, 0, screen_size.x)
	self.position.y = clamp(self.position.y, 0, screen_size.y)


func _select_animation(velocity: Vector2) -> void:

	# caso em que o jogador está se movendo apenas na horizontal.
	if velocity.x != 0 and velocity.y == 0:
		$PlayerAnimatedSprite.animation = "walk"
		$PlayerAnimatedSprite.flip_h = velocity.x < 0

	# caso em que o jogador está se movendo apenas na vertical.
	if velocity.x == 0 and velocity.y != 0:
		$PlayerAnimatedSprite.animation = "up"
		$PlayerAnimatedSprite.flip_v = velocity.y > 0

	# caso em que o jogador está se movendo na horizontal e vertical.
	if velocity.x != 0 and velocity.y != 0:
		$PlayerAnimatedSprite.animation = "walk"
		$PlayerAnimatedSprite.flip_v = velocity.y > 0
		$PlayerAnimatedSprite.flip_h = velocity.x < 0
