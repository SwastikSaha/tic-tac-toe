extends Area2D

# Emitted when this cell is clicked
# Passes itself so the parent board knows exactly which cell triggered the event
signal clicked(this_cell)

# Tracks what is currently placed in this cell (X, O, or empty)
var fill_state = Globals.FillState.FILL_NONE

func _ready():
	# Ensure all visuals start hidden (clean initial state)
	%X.visible = false
	%O.visible = false
	%Trophy.visible = false

# Handles input events specifically on this Area2D
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# Only react to defined "click" action (usually mapped to mouse/touch)
	if event.is_action_pressed("click"):
		clicked.emit(self)  # Notify parent (board) which cell was clicked

# Sets the cell state (X or O) if it's currently empty
func fill(new_fill_state: Globals.FillState):
	# Prevent overwriting an already filled cell
	if fill_state == Globals.FillState.FILL_NONE:
		fill_state = new_fill_state

		# Update visual based on assigned state
		if fill_state == Globals.FillState.FILL_X:
			%X.visible = true
		elif fill_state == Globals.FillState.FILL_O:
			%O.visible = true

# Highlights the cell (used when part of a winning line)
func highlight(enable: bool):
	if enable:
		# Hide X/O and show trophy to indicate winning cell
		$X.visible = false
		$O.visible = false
		$Trophy.visible = true

# Resets cell back to initial empty state
func reset():
	fill_state = Globals.FillState.FILL_NONE

	# Hide all gameplay visuals
	$X.visible = false
	$O.visible = false

	# NOTE: Trophy is set to visible here — likely unintended
	# This would show highlight even on reset (bug or design choice?)
	$Trophy.visible = true
