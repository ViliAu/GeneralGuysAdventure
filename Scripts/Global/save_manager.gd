extends Node

signal saves_loaded
signal save_saved
signal current_save_changed

@onready var save_resource = preload("res://Resources/save_data.tres")

var current_slot: int = -1
var save_slots: Array[SaveData]

const SAVE_PATH = "user://save/"

func load_saves():
	save_slots = []
	var dir := DirAccess.open(SAVE_PATH)
	if dir == null:
		DirAccess.make_dir_recursive_absolute(SAVE_PATH)
		dir = DirAccess.open(SAVE_PATH)
	for s in dir.get_files():
		var file = ResourceLoader.load("%s%s" % [SAVE_PATH, s], "SaveData")
		if file != null:
			save_slots.append(file)
	saves_loaded.emit()

func create_save(save_name: String = "User"):
	var data: SaveData = save_resource.duplicate(true)
	data.name = save_name
	data.path = "%s%s.tres" % [SAVE_PATH, save_name]
	save_slots.append(data)
	current_slot = len(save_slots)-1
	save_current()

func save_current():
	if current_slot >= len(save_slots) || current_slot < 0:
		return
	ResourceSaver.save(save_slots[current_slot], save_slots[current_slot].path)
	save_saved.emit()

func get_current_save() -> SaveData:
	if (len(save_slots)) == 0:
		load_saves()
	save_current()
	return save_slots[current_slot]

func get_all_saves() -> Array[SaveData]:
	load_saves()
	return save_slots

func change_save(slot: int):
	save_current()
	current_slot = slot
	current_save_changed.emit()

func change_save_by_name(save_name: String):
	save_current()
	for i in range(0, len(save_slots)):
		if save_slots[i].name == save_name:
			current_slot = i
	current_save_changed.emit()
