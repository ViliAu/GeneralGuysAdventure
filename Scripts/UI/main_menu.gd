class_name MainMenu extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	load_menu("LandingMenu")

func _on_quit_game_pressed():
	SaveManager.save_current()
	get_tree().quit()

func load_menu(menu_name: String):
	for c: Control in get_children():
		c.visible = false
	var menu: Control = find_child(menu_name)
	menu.visible = true

func _on_new_game_pressed():
	load_menu("NewGameMenu")

func _on_load_game_pressed():
	load_menu("LoadGameMenu")

func _on_back_button_pressed():
	load_menu("LandingMenu")

func _on_new_game_menu_new_save_created():
	load_menu("GameMenu")

func _on_load_game_menu_save_data_loaded():
	load_menu("GameMenu")

func _on_level_select_button_pressed():
	load_menu("LevelSelectMenu")

func _on_shop_button_pressed():
	load_menu("ShopMenu")

func _on_game_menu_back_button_pressed():
	load_menu("GameMenu")

func _on_settings_button_pressed():
	load_menu("SettingsMenu")

func _on_settings_menu_settings_saved():
	load_menu("GameMenu")
