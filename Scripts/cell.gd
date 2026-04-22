extends Area2D
signal clicked(this_cell)
var fill_state = Globals.FillState.FILL_NONE
func _ready():
	%X.visible = false
	%O.visible = false
	%Trophy.visible = false
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		clicked.emit(self)
func fill(new_fill_state: Globals.FillState):
	if fill_state == Globals.FillState.FILL_NONE:
		fill_state = new_fill_state
		if fill_state == Globals.FillState.FILL_X:
			%X.visible = true
		elif fill_state == Globals.FillState.FILL_O:
			%O.visible = true
func highlight(enable: bool):
	if enable:
		$X.visible = false
		$O.visible = false
		$Trophy.visible = true
func reset():
	fill_state = Globals.FillState.FILL_NONE
	$X.visible = false
	$O.visible = false
	$Trophy.visible = true
