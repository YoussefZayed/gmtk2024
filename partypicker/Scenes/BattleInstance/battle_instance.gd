extends Node2D

# need to make this so that it is individual for each instance
func _notification(what):
	if what == NOTIFICATION_WM_MOUSE_ENTER:
		print("enter")
	elif what == NOTIFICATION_WM_MOUSE_EXIT:
		print("exit")
		# Here include code to reset all cards into hand using the _on_card_ui_reparent_requested function in hand.gd
