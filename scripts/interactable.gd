extends Control
class_name Interactable

@export var dialogueIndex = 0
@export var questTiedTo: String = ""
@export var dissapearAfterInteract = false
@export var minimumQuestAmount: int = 0

var hoverShader = load("res://shaders/interactablehover.gdshader")

func _ready():
	self.gui_input.connect(_on_gui_input)
	self.connect("mouse_entered", _on_mouse_entered)
	self.connect("mouse_exited", _on_mouse_exited)
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	material = ShaderMaterial.new()
	material.shader = load("res://shaders/transparencydither.gdshader")
	material.set_shader_parameter("intensity", 0.0)
	
	if dissapearAfterInteract:
		if Global.get(questTiedTo) >= minimumQuestAmount:
			self.visible = false

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		on_click()

func _hide_self():
	if self.material != null:
		var ditherTween = get_tree().create_tween()
		ditherTween.tween_property(self, "material:shader_parameter/intensity", 1.0, 0.2)
		await get_tree().create_timer(0.2).timeout
		self.visible = false
	else:
		self.visible = false

func _on_mouse_entered():
	material.shader = hoverShader

func _on_mouse_exited():
	material.shader = load("res://shaders/transparencydither.gdshader")

func on_click():
	var extraIncrease = 0
	if questTiedTo != "":
		extraIncrease = Global.get(questTiedTo)
	open_dialogue(extraIncrease)

func open_dialogue(extraIncrease = 0):
	var indexSent = dialogueIndex
	if extraIncrease >= minimumQuestAmount and dialogueIndex == 9:
		indexSent += 1
	if extraIncrease != 0 and !dissapearAfterInteract:
		indexSent += extraIncrease
	Global.open_dialogue(indexSent)
	if dissapearAfterInteract and (extraIncrease >= minimumQuestAmount or dialogueIndex != 9):
		Global.get_node("Overlay/Dialogue").connect("dialogue_closed", _hide_self)
