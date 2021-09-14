extends Node

export (PackedScene) var Mob
var score: int

func _ready():
	randomize()


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Prepare-se")


func game_over():
	# ao ser atingido por um Mob, o ScoreTimer deve parar para que não seja
	# incrementada a pontuação do jogador, e MobTimer deve parar para que os
	# Mobs não sejam mais instanciados, uma mensagem de fim de jogo deve
	# aparecer e todos os Mobs devem ser removidos da cena.
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	get_tree().call_group("mobs_group", "queue_free")


func _on_Player_hit():
	# se o jogador entrar em contato com algum Mob, é fim de jogo.
	game_over()


func _on_MobTimer_timeout():
	# escolhendo aleatoriamente um valor entre 0 e 1, ou seja, 
	# de um tamanho 0 até o tamanho máximo da curva.
	$MobPath/MobPathFollow.unit_offset = randf()
	
	# instanciando um Mob e adicionando à cena.
	var mob = Mob.instance()
	add_child(mob)
	
	# calculando a rotação que o Mob deve ter baseada na rotação atual
	# de MobPathFollow somado a 90 graus para ser lançado perpendicularmente.
	var mob_rotation = $MobPath/MobPathFollow.rotation + PI / 2

	# colocando o Mob em uma posição aleatória que foi gerada em randf()
	# no início do método.
	mob.position = $MobPath/MobPathFollow.position
	
	# adicionando à rotação do Mob um valor aleatório entre -45 e 45 graus e 
	# rotacionando o objeto Mob no ângulo calculado.
	mob_rotation += rand_range(-PI / 4, PI / 4)
	mob.rotation = mob_rotation
	
	# pegando um valor aleatório entre a velocidade máxima e mínima do Mob para
	# o eixo x e rotacionando esse vetor no mesmo ângulo que o objeto Mob foi
	# rotacionado.
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(mob_rotation)


func _on_ScoreTimer_timeout():
	# adicionando mais um na pontuação do jogador.
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	# quando se inicia o jogo, o MobTimer deve iniciar para começar a instaciar
	# Mobs e o ScoreTimer deve iniciar para incrementar a pontuação.
	$MobTimer.start()
	$ScoreTimer.start()


func _on_HUD_start_game():
	new_game()
