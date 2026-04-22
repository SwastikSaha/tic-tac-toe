extends Node2D

@onready var bgm = %OptionsMusic

func _ready():
	bgm.play()


func _on_credits_button_pressed() -> void:
	var path = ProjectSettings.globalize_path("res://Credits.html")
	OS.shell_open(path)
	
func _on_how_to_button_pressed() -> void:
	OS.shell_open("https://www.wikihow.com/Play-Tic-Tac-Toe")


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_mute_button_pressed():
	var bus = AudioServer.get_bus_index("Music")
	var muted = AudioServer.is_bus_mute(bus)
	AudioServer.set_bus_mute(bus, !muted)
