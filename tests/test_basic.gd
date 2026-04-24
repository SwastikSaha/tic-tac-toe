extends GutTest

var game

const X = Globals.FillState.FILL_X
const O = Globals.FillState.FILL_O

# ------------------------
# SETUP / TEARDOWN
# ------------------------
func before_each():
	game = load("res://Scenes/game.tscn").instantiate()
	add_child(game)

func after_each():
	if is_instance_valid(game):
		game.queue_free()
	await get_tree().process_frame

# ------------------------
# INITIAL STATE
# ------------------------
func test_initial_turn():
	assert_eq(game.turn, Globals.TurnState.TURN_X)

func test_empty_board():
	for x in range(3):
		for y in range(3):
			assert_eq(game.cells[x][y].fill_state, Globals.FillState.FILL_NONE)

# ------------------------
# CELL FILL
# ------------------------
func test_cell_fill_x():
	var cell = game.cells[0][0]
	cell.fill(X)
	assert_eq(cell.fill_state, X)

func test_cell_fill_o():
	var cell = game.cells[1][1]
	cell.fill(O)
	assert_eq(cell.fill_state, O)

# ------------------------
# WIN CONDITIONS
# ------------------------

# Horizontal
func test_horizontal_win():
	for x in range(3):
		game.cells[x][0].fill(X)

	var result = game.check_win()
	assert_eq(result, X)

# Vertical
func test_vertical_win():
	for y in range(3):
		game.cells[0][y].fill(O)

	var result = game.check_win()
	assert_eq(result, O)

# Main diagonal
func test_main_diagonal_win():
	for i in range(3):
		game.cells[i][i].fill(X)

	var result = game.check_win()
	assert_eq(result, X)

# Anti-diagonal
func test_anti_diagonal_win():
	for i in range(3):
		game.cells[2 - i][i].fill(O)

	var result = game.check_win()
	assert_eq(result, O)

# ------------------------
# DRAW CONDITION
# ------------------------
func test_draw():
	var fills = [
		[X, O, X],
		[X, O, O],
		[O, X, X]
	]

	for x in range(3):
		for y in range(3):
			game.cells[x][y].fill(fills[y][x])

	var result = game.check_win()
	assert_eq(result, -1)

# ------------------------
# NO FALSE POSITIVE
# ------------------------
func test_no_win_incomplete_board():
	game.cells[0][0].fill(X)
	game.cells[1][0].fill(X)

	var result = game.check_win()
	assert_eq(result, 0)

# ------------------------
# TURN SWITCHING
# ------------------------
func test_turn_switch():
	var cell = game.cells[0][0]
	game._on_cell_clicked(cell)

	assert_eq(game.turn, Globals.TurnState.TURN_O)

	game._on_cell_clicked(game.cells[1][0])
	assert_eq(game.turn, Globals.TurnState.TURN_X)

# ------------------------
# PREVENT OVERWRITE
# ------------------------
func test_no_overwrite():
	var cell = game.cells[0][0]
	cell.fill(X)
	cell.fill(O)

	assert_eq(cell.fill_state, X)
