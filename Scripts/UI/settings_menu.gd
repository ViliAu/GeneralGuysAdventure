extends Node

signal settings_saved

var input_to_change = ""
var edited_save: SaveData = null

@export var username_edit: TextEdit
@export var move_up_edit_key: Label
@export var move_left_edit_key: Label
@export var move_down_edit_key: Label
@export var move_right_edit_key: Label
@export var attack_edit_key: Label

func _on_visibility_changed():
	init_settings()

func init_settings():
	edited_save = SaveManager.get_current_save().duplicate()
	update_labels()

func update_labels():
	username_edit.text = edited_save.name
	move_up_edit_key.text = translate_key_name(edited_save.move_up_input)
	move_left_edit_key.text = translate_key_name(edited_save.move_left_input)
	move_down_edit_key.text = translate_key_name(edited_save.move_down_input)
	move_right_edit_key.text = translate_key_name(edited_save.move_right_input)
	attack_edit_key.text = translate_key_name(edited_save.attack_input)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if Input.is_anything_pressed():
		if event is InputEventKey:
			change_input(event.physical_keycode)
		elif event is InputEventMouseButton:
			change_input(event.button_index)

func change_input(input: int):
	match input_to_change:
		"":
			return
		"move_up":
			edited_save.move_up_input = input
		"move_left":
			edited_save.move_left_input = input
		"move_down":
			edited_save.move_down_input = input
		"move_right":
			edited_save.move_right_input = input
		"attack":
			edited_save.attack_input = input
		_:
			pass
	input_to_change = ""
	update_labels()

func _on_move_down_edit_pressed():
	input_to_change = "move_down"

func _on_move_left_edit_pressed():
	input_to_change = "move_left"

func _on_move_up_edit_pressed():
	input_to_change = "move_up"

func _on_move_right_edit_pressed():
	input_to_change = "move_right"

func _on_attack_edit_pressed():
	input_to_change = "attack"

func _on_save_button_pressed():
	var s = SaveManager.get_current_save()
	s.name = edited_save.name
	s.move_up_input = edited_save.move_up_input
	s.move_down_input = edited_save.move_down_input
	s.move_left_input = edited_save.move_left_input
	s.move_right_input = edited_save.move_right_input
	s.attack_input = edited_save.attack_input
	SaveManager.save_current()
	settings_saved.emit()

func _on_username_edit_text_changed():
	edited_save.name = username_edit.text

func translate_key_name(key: int) -> String:
	match(key):
		1:
			return "Mouse1"
		2:
			return "Mouse2"
		3:
			return "Mouse3"
		5:
			return "ScrollDown"
		4:
			return "ScrollUp"
		8:
			return "Thumb1"
		9:
			return "Thumb2"
		_:
			return OS.get_keycode_string(key)
