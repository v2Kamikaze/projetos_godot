extends Control

onready var label: Label = $Label
onready var button: Button = $Button

func _ready():
	button.connect("button_down", self, "_on_Button_button_down")
	button.connect("button_up", self, "_on_Button_button_up")

func _on_Button_button_down() -> void:
	label.text = "Uepaaaaaaaaa!"

func _on_Button_button_up() -> void:
	label.text = "Rapaaaaaaaaz!"
