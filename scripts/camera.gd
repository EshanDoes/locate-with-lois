extends Camera2D

var initialMousePos = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_action_just_pressed("middle_click"):
		initialMousePos = event.position
	elif Input.is_action_pressed("middle_click") and !Global.isDialogue:
		position += initialMousePos - event.position
		initialMousePos = event.position
