extends Node

var canInteract = true
@onready var overlay = $Overlay
@onready var dialogue = $Overlay/Dialogue

# Quest tracking
var pathToFlashlight = 0
var giveFruit = 0
var giveCrystal = 0
var giveTrolphy = 0
var giveWateringCan = 0
var giveFlower = 0

func _enter_tree() -> void:
	pass

func _ready():
	Input.set_custom_mouse_cursor(load("res://sprites/cursor/pointer.png"), Input.CURSOR_POINTING_HAND)
	overlay.visible = false
	dialogue.visible = false

func open_dialogue(index):
	canInteract = false
	overlay.visible = true
	dialogue.get_dialogue(index)

func renew_interact():
	canInteract = true
	overlay.visible = false
