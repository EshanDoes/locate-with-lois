extends Node

var isDialogue = false
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
	overlay.visible = false

func open_dialogue(index):
	isDialogue = true
	overlay.visible = true
	dialogue.get_dialogue(index)

func close_dialogue():
	isDialogue = false
	overlay.visible = false
