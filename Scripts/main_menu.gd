extends Node2D
@onready var menu_music = %MenuMusic

func _on_play_button_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(menu_music, "volume_db", -80, 0.3)
	await tween.finished
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")

func _ready():
	menu_music.play()

func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/options.tscn")
