extends Node2D

signal health_changed
signal died

enum STATES {ALIVE, DEAD}

export var max_health: int = 18
var health: int = max_health

export var max_energy: int = 12
var energy: int = max_energy

var state = STATES.ALIVE


func take_damage(damage: int, damage_on_energy: int):
	if state == STATES.DEAD:
		return

	health -= damage
	if health <= 0:
		health = 0
		state = STATES.DEAD
		emit_signal("died")
	
	energy -= damage_on_energy
	if energy <= 0:
		energy = 0
	
	$AnimationPlayer.play("take_hit")
	# Emitimos um sinal e passamos a vida e a energia atualizadas.
	emit_signal("health_changed", health, energy)


func _on_AnimationPlayer_animation_finished(name: String):
	# Se o jogador não estiver morto, não fazemos nada.
	if state != STATES.DEAD:
		return
	# Se a animação não for a de tomar dano, também não fazemos nada.
	if name != "take_hit":
		return
	# Agora se o jogador estiver no estado de morto e a animação de tomar dano
	# estiver finalizada, iniciamos a animação de morte.
	$AnimationPlayer.play("die")
