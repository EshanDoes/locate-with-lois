extends Camera2D

var initialMousePos = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if Input.is_action_just_pressed("drag_camera"):
		initialMousePos = event.position
	elif Input.is_action_pressed("drag_camera") and Global.canInteract:
		position += initialMousePos - event.position
		initialMousePos = event.position
