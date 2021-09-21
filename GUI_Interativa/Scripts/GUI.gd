extends MarginContainer

onready var life_number_label: Label = $Bars/LifeBar/Count/Background/Number
onready var life_bar: TextureProgress = $Bars/LifeBar/TextureProgress

onready var energy_number_label: Label = $Bars/EnergyBar/Count/Background/Number
onready var energy_bar: TextureProgress = $Bars/EnergyBar/TextureProgress

onready var tween: Tween = $Tween

var player_max_health: int
var player_max_energy: int

var animated_health: int
var animated_energy: int


func _ready():
	var player = $"../Characters/Player"
	player_max_health = player.max_health
	life_bar.max_value = player_max_health
	life_number_label.text = str(player_max_health)
	
	player_max_energy = player.max_energy
	energy_bar.max_value = player_max_energy
	energy_number_label.text = str(player_max_energy)
	
	animated_health = player_max_health
	animated_energy = player_max_energy

func _process(_delta: float):
	life_number_label.text = str(animated_health)
	life_bar.value = animated_health

	energy_number_label.text = str(animated_energy)
	energy_bar.value = animated_energy

func update_health(new_value: int):
	tween.interpolate_property(self, "animated_health", animated_health, new_value, 0.6)
	if not tween.is_active():
		tween.start()


func update_energy(new_value: int):
	tween.interpolate_property(self, "animated_energy", animated_energy, new_value, 0.6)
	if not tween.is_active():
		tween.start()
	

func _on_Player_health_changed(player_health: int, player_energy: int):
	# Quando o jogador receber dano, modificamos sua vida e sua energy na GUI
	# usando animações com tween.
	update_health(player_health)
	update_energy(player_energy)


func _on_Player_died():
	# Quando o jogador morrer, a GUI deve desaparecer lentamente usando tween.
	var start_color = Color(1.0, 1.0, 1.0, 1.0)
	var end_color = Color(1.0, 1.0, 1.0, 0.0)
	
	tween.interpolate_property(self, "modulate", start_color, end_color, 1.0)
	
	if not tween.is_active():
		tween.start()
