extends Node2D
#References for the Objects used
@onready var player_label = %PlayerLabel
@onready var player_icon = %PlayerIcon
@onready var game_over_banner = %GameOverBanner
@onready var left_char = %LeftCharacter
@onready var right_char = %RightCharacter
@onready var bgm = %BackGroundMusic
@onready var restart_button = %RestartButton
@onready var quit_button = %QuitButton
#Preloading some assets
const MARIO_ICON = preload("res://Assets/mario_stat.png")
const LUIGI_ICON = preload("res://Assets/luigi_stat.png")
const MARIO_TEXT = preload("res://Assets/Player1.png")
const LUIGI_TEXT = preload("res://Assets/Player2.png")
const MARIO_HAPPY = preload("res://Assets/mario_win.png")
const MARIO_SAD   = preload("res://Assets/mario_loss.png")
const LUIGI_HAPPY = preload("res://Assets/luigi_win.png")
const LUIGI_SAD   = preload("res://Assets/luigi_loss.png")
const NEUTRAL = preload("res://Assets/draw_image.png")
var cell_scene = preload("res://Scenes/cell.tscn")
#Some other useful variables and constants
var cells = []
const board_size = Vector2i(3, 3)
var turn = Globals.TurnState.TURN_X
var is_game_over = false
#binding of shortcuts
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset_game"):
		get_tree().reload_current_scene()
#The starting function
func _ready():
	for x in range(board_size.x):
		cells.append([])
		for y in range(board_size.y):
			var cell = cell_scene.instantiate()
			add_child(cell)
			cells[x].append(cell)
			cell.global_position = Vector2(85 + x*100, 130 + y*100)
			cell.clicked.connect(_on_cell_clicked)
	%Board.global_position = Vector2(64.5 + 163.5, 240 + 20)
	update_current_player_ui()
	bgm.play()
	restart_button.visible = false
	quit_button.visible = false
func _on_cell_clicked(cell):
	if cell.fill_state != Globals.FillState.FILL_NONE:
		return
	var fill_to_use
	if turn == Globals.TurnState.TURN_X:
		fill_to_use = Globals.FillState.FILL_X
	else:
		fill_to_use = Globals.FillState.FILL_O
	cell.fill(fill_to_use)
	var current_player = fill_to_use
	if turn == Globals.TurnState.TURN_X:
		turn = Globals.TurnState.TURN_O
	else:
		turn = Globals.TurnState.TURN_X
	update_current_player_ui()
	var result = check_win()
	if result == 0:
		play_click_sound(current_player)
	elif result == Globals.FillState.FILL_X or result == Globals.FillState.FILL_O:
		play_win_sound(result)
	elif result == -1:
		play_draw_sound()
func check_win() -> int:
	var win_state = true
	var first_cell_state = Globals.FillState.FILL_NONE
	for y in range(board_size.y):
		win_state = true
		for x in range(board_size.x):
			var cell = cells[x][y]
			if x == 0:
				if cell.fill_state == Globals.FillState.FILL_NONE:
					win_state = false
					break
				first_cell_state = cell.fill_state
			elif cell.fill_state != first_cell_state:
				win_state = false
				break
		if win_state:
			is_game_over = true
			for x in range(board_size.x):
				cells[x][y].highlight(true)
			show_game_over_characters(first_cell_state)
			show_game_over_ui() 
			return first_cell_state 
	for x in range(board_size.x):
		win_state = true
		for y in range(board_size.y):
			var cell = cells[x][y]
			if y == 0:
				if cell.fill_state == Globals.FillState.FILL_NONE:
					win_state = false
					break
				first_cell_state = cell.fill_state
			elif cell.fill_state != first_cell_state:
				win_state = false
				break
		if win_state:
			is_game_over = true
			for y in range(board_size.y):
				cells[x][y].highlight(true)
			show_game_over_characters(first_cell_state)
			show_game_over_ui() 
			return first_cell_state
	win_state = true
	for i in range(board_size.x):
		var cell = cells[i][i]
		if i == 0:
			if cell.fill_state == Globals.FillState.FILL_NONE:
				win_state = false
				break
			first_cell_state = cell.fill_state
		elif cell.fill_state != first_cell_state:
			win_state = false
			break
	if win_state:
		is_game_over = true
		for i in range(board_size.x):
			cells[i][i].highlight(true)
		show_game_over_characters(first_cell_state)
		show_game_over_ui() 
		return first_cell_state
	win_state = true
	for i in range(board_size.x):
		var cell = cells[2 - i][i]
		if i == 0:
			if cell.fill_state == Globals.FillState.FILL_NONE:
				win_state = false
				break
			first_cell_state = cell.fill_state
		elif cell.fill_state != first_cell_state:
			win_state = false
			break
	if win_state:
		is_game_over = true
		for i in range(board_size.x):
			cells[2 - i][i].highlight(true)
		show_game_over_characters(first_cell_state)
		show_game_over_ui()
		return first_cell_state
	var is_draw = true
	for x in range(board_size.x):
		for y in range(board_size.y):
			if cells[x][y].fill_state == Globals.FillState.FILL_NONE:
				is_draw = false
				break
		if not is_draw:
			break
	if is_draw:
		is_game_over = true
		show_game_over_characters(-1)
		show_game_over_ui() 
		return -1 
	return 0 
func restart_game():
	is_game_over = false
	turn = Globals.TurnState.TURN_X
	show_gameplay_ui()
	update_current_player_ui()
	get_tree().reload_current_scene()
func play_click_sound(player):
	lower_bgm()
	var to_play: AudioStreamPlayer
	if player == Globals.FillState.FILL_X:
		to_play = %MarioPlaySound
	else:
		to_play = %LuigiPlaySound
	to_play.pitch_scale = randf_range(0.95, 1.05) 
	to_play.play()
	await to_play.finished
	restore_bgm()
func play_win_sound(player):
	lower_bgm()
	var to_play: AudioStreamPlayer
	if player == Globals.FillState.FILL_X:
		to_play = %MarioWinSound
	else:
		to_play = %LuigiWinSound
	to_play.play()
	await to_play.finished
	restore_bgm()
func update_current_player_ui():
	if turn == Globals.TurnState.TURN_X:
		player_label.texture = MARIO_TEXT
		player_icon.texture = MARIO_ICON
	else:
		player_label.texture = LUIGI_TEXT
		player_icon.texture = LUIGI_ICON
func show_game_over_ui():
	player_label.visible = false
	player_icon.visible = false
	game_over_banner.visible = true
	restart_button.visible = true
	quit_button.visible = true
func show_gameplay_ui():
	player_label.visible = true
	player_icon.visible = true
	game_over_banner.visible = false
	restart_button.visible = false
	quit_button.visible = false
func play_draw_sound():
	lower_bgm()
	var to_play: AudioStreamPlayer = %DrawSound
	to_play.play()
	await to_play.finished
	restore_bgm()
func show_game_over_characters(result):
	player_label.visible = false
	player_icon.visible = false
	left_char.visible = true
	right_char.visible = true
	if result == Globals.FillState.FILL_X:
		left_char.texture = MARIO_HAPPY
		right_char.texture = LUIGI_SAD
	elif result == Globals.FillState.FILL_O:
		left_char.texture = MARIO_SAD
		right_char.texture = LUIGI_HAPPY
	elif result == -1:
		left_char.texture = NEUTRAL
		right_char.texture = NEUTRAL
		left_char.scale = Vector2.ONE
		right_char.scale = Vector2.ONE
		left_char.flip_h = false
		right_char.flip_h = true
		var common_y = left_char.position.y
		right_char.position.y = common_y
func lower_bgm():
	bgm.volume_db = -15  
func restore_bgm():
	bgm.volume_db = 0
func _on_restart_button_pressed():
	restart_game()
func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
