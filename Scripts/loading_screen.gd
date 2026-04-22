extends Control

@onready var anim = %Animation_Bar
@onready var music = %Music

func _ready():
	anim.play()
	music.play()
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
