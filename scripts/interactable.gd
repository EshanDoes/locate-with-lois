extends Control

@export var dialogueIndex = 0


func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		Global.open_dialogue(dialogueIndex)
