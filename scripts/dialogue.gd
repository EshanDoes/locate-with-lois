extends Node

var dialogueJSON = "res://dialogue.json"
@onready var dialogueBox = $"Dialogue Box"
@onready var dialogueText = $Dialogue
@onready var nameText = $Name
@onready var npcExpression = $"NPC Expression"
@onready var loisExpression = $"Lois Expression"
@export var animationDuration = 0.2
@export var animationPosition = 10.0
@export var dialogueSpeed = 30.0

var dialogue
var currentDialogue
var dialogueNow = -1
var npcTalkedTo
var dialogueAppearing = false
var untilNextChar = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load the JSON file
	var file = FileAccess.open(dialogueJSON, FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var data = JSON.parse_string(json_text)
		
		if typeof(data) == TYPE_ARRAY:
			dialogue = data
			
			#print("Dialogue list: " + str(dialogue))
		else:
			print("Invalid JSON structure.")
	else:
		print("Failed to open file.")
	
	# Set dialogue box properties to base values
	dialogueBox.material.set_shader_parameter("intensity", 1.0)
	self.position.y = animationPosition
	self.modulate.a = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dialogueAppearing:
		untilNextChar += delta * dialogueSpeed
		if dialogueText.visible_characters < dialogueText.text.length():
			if untilNextChar >= 1:
				dialogueText.visible_characters += 1
				untilNextChar -= 1
		else:
			dialogueAppearing = false
			untilNextChar = 0.0

func get_dialogue(index):
	dialogueNow = -1
	npcTalkedTo = dialogue[index]["npc"]
	currentDialogue = dialogue[index]["dialogue"]
	if dialogue[index].has("propertyChange"):
		Global.set(dialogue[index]["propertyChange"]["name"], dialogue[index]["propertyChange"]["value"])
	npcExpression.texture = load("res://sprites/expressions/"+npcTalkedTo+"/neutral.png")
	loisExpression.texture = load("res://sprites/expressions/Lois/neutral.png")
	next_dialogue()
	
	var ditherTween = get_tree().create_tween()
	var moveTween = get_tree().create_tween()
	var opacityTween = get_tree().create_tween()
	ditherTween.tween_property(dialogueBox, "material:shader_parameter/intensity", 0.0, animationDuration)
	moveTween.tween_property(self, "position:y", 0, animationDuration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	opacityTween.tween_property(self, "modulate:a", 1, animationDuration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)

func next_dialogue():
	dialogueNow += 1
	if dialogueNow < currentDialogue.size():
		dialogueText.text = currentDialogue[dialogueNow]["dialogue"]
		dialogueText.visible_characters = 0
		dialogueAppearing = true
		if currentDialogue[dialogueNow]["npcTalking"]:
			if dialogueNow == 0:
				expression_priority_animation(npcExpression, loisExpression, 0)
			else:
				expression_priority_animation(npcExpression, loisExpression)
			nameText.text = npcTalkedTo
			npcExpression.texture = load("res://sprites/expressions/"+npcTalkedTo+"/"+currentDialogue[dialogueNow]["expression"]+".png")
		else:
			if dialogueNow == 0:
				expression_priority_animation(loisExpression, npcExpression, 0)
			else:
				expression_priority_animation(loisExpression, npcExpression)
			nameText.text = "Lois"
			loisExpression.texture = load("res://sprites/expressions/Lois/"+currentDialogue[dialogueNow]["expression"]+".png")
	else:
		var ditherTween = get_tree().create_tween()
		var moveTween = get_tree().create_tween()
		var opacityTween = get_tree().create_tween()
		ditherTween.tween_property(dialogueBox, "material:shader_parameter/intensity", 1.0, animationDuration)
		moveTween.tween_property(self, "position:y", animationPosition, animationDuration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
		opacityTween.tween_property(self, "modulate:a", 0, animationDuration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
		
		await get_tree().create_timer(animationDuration).timeout
		Global.close_dialogue()

func expression_priority_animation(talkingCharacter, otherCharacter, expressionAnimationDuration = animationDuration):
	var talkingCharacterModulateTween = get_tree().create_tween()
	var talkingCharacterPositionTween = get_tree().create_tween()
	var otherCharacterModulateTween = get_tree().create_tween()
	var otherCharacterPositionTween = get_tree().create_tween()
	
	talkingCharacterModulateTween.tween_property(talkingCharacter, "modulate", Color(1, 1, 1, 1), expressionAnimationDuration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	talkingCharacterPositionTween.tween_property(talkingCharacter, "position:y", 0, expressionAnimationDuration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	otherCharacterModulateTween.tween_property(otherCharacter, "modulate", Color(0.8, 0.8, 0.8, 1), expressionAnimationDuration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	otherCharacterPositionTween.tween_property(otherCharacter, "position:y", 16, expressionAnimationDuration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)

func _input(event):
	if event.is_action_pressed("progress_dialogue") and Global.isDialogue:
		next_dialogue()
