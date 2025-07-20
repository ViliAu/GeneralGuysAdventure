extends Node

signal enemies_reduced
signal wave_finished
signal wave_started
signal money_collected

var ogre_resource = preload("res://Scenes/Enemy/ogre.tscn")

var wave = 0
var kills = 0
var collected_money = 0

var level_data: Level

var player: Player = null

var enemy_list: Array[Ogre] = []
var enemies_left = 0

func reset_game():
	print("game reset!")
	player = null
	wave = 0
	kills = 0
	collected_money = 0
	level_data = LevelManager.loaded_level
	
	var new_wave_timer = Timer.new()
	new_wave_timer.wait_time = 5
	new_wave_timer.one_shot = true
	new_wave_timer.timeout.connect(begin_new_wave)
	new_wave_timer.autostart = true
	add_child(new_wave_timer)
	wave_finished.emit()

func get_equipment_difficulty():
	var diff := float(wave)/level_data.waves_per_difficulty_increase
	var rng = RandomNumberGenerator.new().randfn(diff, level_data.difficulty_variance) + level_data.start_difficulty
	return clampi(rng, 0, 5)

func get_player() -> Player:
	if player == null:
		var player_list = get_tree().get_root().find_children("*", "Player", true, false) as Array[Player]
		if len(player_list) > 0:
			player = player_list[0]
	return player

func on_ogre_death():
	enemies_left -= 1
	kills += 1
	enemies_reduced.emit()
	print("ogre dead!")
	if enemies_left <= 0:
		wave_finished.emit()
		var new_wave_timer = Timer.new()
		new_wave_timer.wait_time = 5
		new_wave_timer.one_shot = true
		new_wave_timer.timeout.connect(begin_new_wave)
		new_wave_timer.autostart = true
		add_child(new_wave_timer)

		# Award player money per wave
		on_money_collected(wave)
		print("Round over!")

func begin_new_wave():
	print("begun new wave!")
	LevelManager.clear_enemies()
	wave += 1
	enemies_left = wave * level_data.enemies_per_wave
	spawn_enemies_for_wave(enemies_left)
	wave_started.emit()

func spawn_enemies_for_wave(spawns_left: int):
	if LevelManager.loaded_level == null:
		return
	var ogre: Ogre = LevelManager.spawn_ogre()
	print("ogre spawned!")
	enemy_list.append(ogre)
	ogre.on_death.connect(on_ogre_death)
	spawns_left -= 1
	if spawns_left <= 0:
		return
	else:
		var t: Timer = Timer.new()
		t.wait_time = 1
		t.one_shot = true
		t.autostart = true
		t.timeout.connect(func(): spawn_enemies_for_wave(spawns_left))
		add_child(t)

func on_money_collected(amount: int):
	collected_money += amount
	money_collected.emit()

func on_player_death():
	SaveManager.get_current_save().money += collected_money
	SaveManager.save_current()