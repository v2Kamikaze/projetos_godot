extends CanvasLayer

signal start_game


func show_message(text: String) -> void:
	# definindo o texto da label no texto passado.
	$MessageLabel.text = text
	# tornando a label visível.
	$MessageLabel.show()
	# iniciando o timer.
	$MessageTimer.start()


func show_game_over() -> void:
	show_message("Fim de jogo")
	# iniciando uma corrotina que espera o sinal de timeout do timer para 
	# liberar a execução do resto da função, desse modo, a mensagem de fim de 
	# jogo é exibida por apenas alguns segundos e volta para o texto inicial 
	# "Dodge the Creeps!" do jogo.
	yield($MessageTimer, "timeout")
	
	$MessageLabel.text = "Dodge the\nCreeps!"
	$MessageLabel.show()
	
	# iniciando outra corrotina, aqui é criado um timer no árvore de Nós da 
	# cena, com wait_time de 1 segundo, assim esperamos 1 segundo para que o 
	# botão de iniciar o jogo seja exibido.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()


func update_score(new_score: int) -> void:
	$ScoreLabel.text = str(new_score)


func _on_MessageTimer_timeout():
	$MessageLabel.hide()


func _on_StartButton_pressed():
	# escondendo o botão
	$StartButton.hide()
	# como o botão foi pressionado, o jogo começou, então emitimos o sinal de
	# "start_game".
	emit_signal("start_game")
