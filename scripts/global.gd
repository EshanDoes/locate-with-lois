extends Node

var canInteract = true
@onready var overlay = $Overlay
@onready var dialogue = $Overlay/Dialogue
@onready var roomTransition = $"Overlay/Room Transition"
@export var transitionDuration = 0.6

# Quest tracking
var pathToFlashlight = 0
var giveFruit = 0
var giveCrystal = 0
var giveTrophy = 0
var giveWateringCan = 0
var giveFlower = 0

func _ready():
	Input.set_custom_mouse_cursor(load("res://sprites/cursor/pointer.png"), Input.CURSOR_POINTING_HAND)
	dialogue.visible = false
	overlay.visible = false
	canInteract = true

func open_dialogue(index):
	canInteract = false
	overlay.visible = true
	dialogue.get_dialogue(index)

func renew_interact():
	if giveFlower >= 2:
		$"Overlay/Win Screen".open()
	else:
		canInteract = true
		overlay.visible = false
		dialogue.visible = false
		roomTransition.visible = false

func change_room(room: Node):
	overlay.visible = true
	roomTransition.visible = true
	canInteract = false
	
	var transitionTween = create_tween()
	var opacityTween = create_tween()
	transitionTween.tween_property(roomTransition, "material:shader_parameter/progress", 0.0, transitionDuration)
	opacityTween.tween_property(roomTransition, "modulate:a", 1.0, transitionDuration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	await get_tree().create_timer(transitionDuration).timeout
	$"/root/World".free()
	get_tree().root.add_child(room)
	
	await get_tree().create_timer(0.15).timeout
	new_room_transition()

func new_room_transition():
	canInteract = false
	overlay.visible = true
	
	roomTransition.set_instance_shader_parameter("progress", 0.0)
	var transitionTween = get_tree().create_tween()
	var opacityTween = get_tree().create_tween()
	transitionTween.tween_property(roomTransition, "material:shader_parameter/progress", 1.0, transitionDuration)
	opacityTween.tween_property(roomTransition, "modulate:a", 0.0, transitionDuration).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	await get_tree().create_timer(transitionDuration).timeout
	renew_interact()
	
