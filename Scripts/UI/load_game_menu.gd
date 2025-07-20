extends Control

signal save_data_loaded

@export var button_scene: PackedScene

@onready var button_holder: VBoxContainer = $"./VBoxContainer/ScrollContainer/VBoxContainer"

func _on_visibility_changed():
	for c: Button in button_holder.get_children():
		c.queue_free()
	var saves: Array[SaveData] = SaveManager.get_all_saves()
	for s: SaveData in saves:
		print(s.name)
		var b: Button = button_scene.instantiate()
		b.text = s.name
		b.pressed.connect(func(): button_press_callback(s.name))
		button_holder.add_child(b)

func button_press_callback(text: String):
	print(text)
	SaveManager.change_save_by_name(text)
	save_data_loaded.emit()
