extends Node

@onready var ui: MainMenu

func _ready():
	ui = get_tree().root.find_children("*", "MainMenu", true, false) as Array[MainMenu][0]

func start_game(level: int):
	LevelManager.load_level(level)
	ui.visible = false

func end_game():
	LevelManager.clear_level()
	ui.visible = true
	ui.load_menu("GameMenu")