extends Area2D

signal hit

export(int) var speed: int = 400
onready var screen_size: Vector2 = get_viewport_rect().size

func _ready() -> void:
	hide()


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
	select_animation(velocity)
	
	position +=  velocity * delta
	# mantendo a posição do jogador entre os limites da tela.
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)


func select_animation(velocity: Vector2) -> void:

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


func start(start_pos: Vector2):
	position = start_pos
	show() # deixando o jogador visível novamente.
	$PlayerHitBox.disabled = false # reativando a HitBox do jogador.


func _on_Player_body_entered(_body: Node) -> void:
	hide() # o jogador terá morrido, então não deverá ser visível.
	emit_signal("hit") # emitindo o sinal de que o jogador foi atingido.
	$PlayerHitBox.set_deferred("disabled", true) # desativando a HitBox do jogador.
