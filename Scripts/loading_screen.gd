extends Control

# Cached references to animation and background music nodes
@onready var anim = %Animation_Bar
@onready var music = %Music

func _ready():
	# Start the intro animation immediately when scene loads
	anim.play()

	# Start background music (runs independently of animation)
	music.play()

	# Wait asynchronously for 5 seconds before proceeding
	# This does NOT block the engine; it yields execution
	await get_tree().create_timer(5.0).timeout

	# After delay, transition to main gameplay scene
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
