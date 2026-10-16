extends Control
class_name UIOverlay

@export var animationDuration = 0.35
@export var animationPosition = 20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false

func open():
	self.visible = true
	
	var ditherTween = get_tree().create_tween()
	var moveTween = get_tree().create_tween()
	var opacityTween = get_tree().create_tween()
	
	ditherTween.tween_property(self, "material:shader_parameter/intensity", 0.0, animationDuration)
	moveTween.tween_property(self, "position:y", 0, animationDuration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	opacityTween.tween_property(self, "modulate:a", 1, animationDuration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)

func close():
	var ditherTween = get_tree().create_tween()
	var moveTween = get_tree().create_tween()
	var opacityTween = get_tree().create_tween()
	
	ditherTween.tween_property(self, "material:shader_parameter/intensity", 1.0, animationDuration)
	moveTween.tween_property(self, "position:y", animationPosition, animationDuration).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CIRC)
	opacityTween.tween_property(self, "modulate:a", 0, animationDuration).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
	
	await get_tree().create_timer(animationDuration).timeout
	Global.renew_interact()
	self.visible = false
