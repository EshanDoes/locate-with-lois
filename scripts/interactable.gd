extends Control
class_name Interactable

@export var dialogueIndex = 0
@export var questTiedTo = ""
@export var dissapearAfterInteract = false

func _ready():
	self.gui_input.connect(_on_gui_input)
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	material = ShaderMaterial.new()
	material.shader = load("res://shaders/transparencydither.gdshader")
	material.set_shader_parameter("intensity", 0.0)

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
		await get_tree().create_timer(0.2).timeout
		self.visible = false
	else:
		self.visible = false

func _on_mouse_entered():
	print("Entered")

func _on_mouse_exited():
	print("Exited")
