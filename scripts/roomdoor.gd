extends Interactable
class_name RoomDoor

@export var room: PackedScene
@export var questMinimumToEnter = 0

func on_click():
	var questProgress = Global.get(questTiedTo)
	if questProgress >= questMinimumToEnter:
		Global.change_room(room)
	else:
		open_dialogue()
