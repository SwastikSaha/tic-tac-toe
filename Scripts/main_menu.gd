extends Node2D

# Reference to menu background music player
@onready var menu_music = %MenuMusic

# --- Play button handler ---
func _on_play_button_pressed() -> void:
	# Create a tween to smoothly fade out the music
	var tween = create_tween()

	# Animate volume from current level to near silence (-80 dB)
	tween.tween_property(menu_music, "volume_db", -80, 0.3)

	# Wait until fade-out completes before switching scene
	await tween.finished

	# Transition to loading screen (intermediate scene)
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")

# --- Scene initialization ---
func _ready():
	# Start menu music when scene loads
	menu_music.play()

# --- Options button handler ---
func _on_options_button_pressed():
	# Direct transition to options/settings screen
	get_tree().change_scene_to_file("res://Scenes/options.tscn")
