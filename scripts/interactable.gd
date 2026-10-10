extends Control

@export var dialogueIndex = 0
@export var questTiedTo = ""

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		var indexSent = dialogueIndex
		if questTiedTo != "":
			indexSent += Global.get(questTiedTo)
		Global.open_dialogue(indexSent)
