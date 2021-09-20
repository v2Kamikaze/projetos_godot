extends Area2D

signal hit

export(int) var speed: int = 400

onready var screen_size: Vector2 = get_viewport_rect().size

var target: Vector2 = Vector2.ZERO

func _ready() -> void:
	hide()


func _process(delta) -> void:
	move_player(delta)


func _input(event: InputEvent):
	# Atualizando a posição para onde o jogador deve se mover toda vez que
	# tiver um evento de mouse ou touch.
	if event is InputEventScreenTouch and event.is_pressed():
		target = event.position


func move_player(delta: float) -> void:
	var velocity = Vector2.ZERO
	# enquanto a distância entre a posição atual do jogador e a posição 
	# alvo atual for maior que 10 unidades, o jogador irá se movimentar 
	# até a posição alvo.
	if position.distance_to(target) > 10:
		velocity = target - position
	
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
	# mudando a animação de acordo com a direção que o personagem tomar.
	if velocity.x != 0:
		$PlayerAnimatedSprite.animation = "walk"
		$PlayerAnimatedSprite.flip_v = false
		$PlayerAnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$PlayerAnimatedSprite.animation = "up"
		$PlayerAnimatedSprite.flip_v = velocity.y > 0


func start(start_pos: Vector2):
	position = start_pos
	show() # deixando o jogador visível novamente.
	$PlayerHitBox.disabled = false # reativando a HitBox do jogador.


func _on_Player_body_entered(_body: Node) -> void:
	hide() # o jogador terá morrido, então não deverá ser visível.
	emit_signal("hit") # emitindo o sinal de que o jogador foi atingido.
	
	# desativando a HitBox do jogador após o passo de física atual 
	# para que não ocorra um erro.
	$PlayerHitBox.set_deferred("disabled", true) 
