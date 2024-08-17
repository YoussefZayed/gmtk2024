extends CardState

const DRAG_MINIMUM_THRESHOLD := 0.05 # time in seconds

var minimum_drag_time_elapsed := false

func enter() -> void:
	var ui_layer := get_parent().get_parent().get_parent().get_parent().get_parent() # only works with the current tree, needs fixing to reference in a more flexible way
	if ui_layer:
		card_ui.reparent(ui_layer)
	
	card_ui.color.color = Color.NAVY_BLUE
	card_ui.state.text = "DRAGGING"
	
	minimum_drag_time_elapsed = false
	var threshold_timer := get_tree().create_timer(DRAG_MINIMUM_THRESHOLD, false)
	threshold_timer.timeout.connect(func():minimum_drag_time_elapsed = true)

func on_input(event: InputEvent) -> void:
	var single_targeted := card_ui.card.is_single_targeted()
	var mouse_motion := event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	var confirm = event.is_action_released("left_mouse") or event.is_action_released("left_mouse")
	
	if single_targeted and mouse_motion and card_ui.targets.size() > 0:
		transition_requested.emit(self, CardState.State.AIMING)
		return
	
	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
	
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	elif minimum_drag_time_elapsed and confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
