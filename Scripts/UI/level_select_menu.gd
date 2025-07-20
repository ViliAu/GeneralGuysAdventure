extends Node

func _on_level_1_button_pressed():
	print("Starting level 1")
	GameManager.start_game(0)

func _on_level_2_button_pressed():
	print("Starting level 2")
	GameManager.start_game(1)

func _on_level_3_button_pressed():
	print("Starting level 3")
	GameManager.start_game(2)

func _on_level_4_button_pressed():
	print("Starting level 4")
	GameManager.start_game(3)