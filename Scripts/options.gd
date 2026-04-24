extends Node2D

# Background music specific to the options menu
@onready var bgm = %OptionsMusic

func _ready():
	# Start playing options menu music when scene loads
	bgm.play()

# --- Opens local credits file in default system browser ---
func _on_credits_button_pressed() -> void:
	# Directly opens a web URL
	OS.shell_open("https://github.com/SwastikSaha/tic-tac-toe/blob/main/Credits.html")

# --- Opens external guide in browser ---
func _on_how_to_button_pressed() -> void:
	# Directly opens a web URL
	OS.shell_open("https://www.wikihow.com/Play-Tic-Tac-Toe")

# --- Return to main menu ---
func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

# --- Toggle mute state of "Music" audio bus ---
func _on_mute_button_pressed():
	# Get index of the "Music" bus (must exist in Audio Bus Layout)
	var bus = AudioServer.get_bus_index("Music")

	# Query current mute state
	var muted = AudioServer.is_bus_mute(bus)

	# Toggle mute (true → false, false → true)
	AudioServer.set_bus_mute(bus, !muted)
