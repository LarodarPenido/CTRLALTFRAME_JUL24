extends CenterContainer

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:

		hide()
