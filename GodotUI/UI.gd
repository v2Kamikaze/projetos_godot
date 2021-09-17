extends Control

onready var health_bar: TextureProgress = $TextureProgress

func _ready():
	$Timer.start()
	$Timer.connect("timeout", self, "increase_bar")


func increase_bar():
	if health_bar.value == health_bar.max_value:
		$Timer.stop()
		$Label.text = "HP cheio"
	health_bar.value += 5
