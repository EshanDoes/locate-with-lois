extends Interactable
class_name RoomDoor

@export_file("*.tscn") var roomPath

func on_click():
	var questProgress = Global.get(questTiedTo)
	if questProgress >= minimumQuestAmount:
		var room = load(roomPath)
		Global.change_room(room.instantiate())
	else:
		open_dialogue()
