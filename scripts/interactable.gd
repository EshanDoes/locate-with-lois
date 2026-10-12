extends Control

@export var dialogueIndex = 0
@export var questTiedTo = ""
@export var dissapearAfterInteract = false

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		var indexSent = dialogueIndex
		if questTiedTo != "":
			indexSent += Global.get(questTiedTo)
		Global.open_dialogue(indexSent)
		if dissapearAfterInteract:
			Global.get_node("Overlay/Dialogue").connect("dialogue_closed", _hide_self)

func _hide_self():
	if self.material != null:
		var ditherTween = get_tree().create_tween()
		ditherTween.tween_property(self, "material:shader_parameter/intensity", 1.0, 0.2)
	else:
		self.visible = false
