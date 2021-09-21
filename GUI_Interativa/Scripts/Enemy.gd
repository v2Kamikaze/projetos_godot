extends Node2D

enum STATES {IDLE, ATTACKING}
var state = STATES.IDLE

export var strength: int = 6
export var damage_on_energy: int = 4 

onready var target = $"../Player"


func _on_Timer_timeout():
	# Se o alvo tiver morrido, o timer deve parar e não se deve fazer nada.
	if not target:
		$Timer.stop()
		return

	# Se já estiver no estado de atacar, não precisa mudar o estado e nem fazer
	# nada.
	if state != STATES.IDLE:
		return
	
	# Se não estiver com o estado de atacar, mudamos o estado para atacar,
	# e ativamos a animação de antecipação, que nada mais é do que dar um passo
	# para trás.
	state = STATES.ATTACKING
	$AnimationPlayer.play("anticipate")


func damage_and_tire_target(player, damage: int, damage_energy: int):
	player.take_damage(damage, damage_energy)


func _on_AnimationPlayer_animation_finished(name: String):
	
	# Ao finalizar a animação, verificamos que animação foi concluída.
	
	# Se foi a animação de atacar, significa que já um ataque já foi finalizado
	# e foi causado dano ao jogador, voltamos ao estado de parado, se preparando
	# assim para outro ataque caso não tenha matado o jogador.
	
	# Se foi a animação de antecipar, devemos atacar o jogador, causando dano 
	# na vida e reduzindo a energia do jogador, e ativar a animação de atacar.
	if name == "attack":
		state = STATES.IDLE
	if name == "anticipate":
		$AnimationPlayer.play("attack")
		damage_and_tire_target(target, strength, damage_on_energy)


func _on_Player_died():
	# Se o jogador morrer, referenciamos o alvo para um valor nulo.
	target = null
