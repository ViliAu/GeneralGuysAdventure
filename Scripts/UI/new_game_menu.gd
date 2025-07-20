extends Node

signal new_save_created

@export var name_edit_text: TextEdit

func _on_new_save_button_pressed():
	SaveManager.create_save(name_edit_text.text)
	SaveManager.load_saves()
	new_save_created.emit()
