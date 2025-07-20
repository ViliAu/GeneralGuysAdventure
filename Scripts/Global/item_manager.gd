extends Node

func get_stats_from_player_items() -> PlayerStats:
	var current_save = SaveManager.get_current_save()
	var stats := PlayerStats.new()
	var equipment_list: Array[Equipment] = []
	equipment_list.append(ItemDatabase.player_helmets[current_save.helmet])
	equipment_list.append(ItemDatabase.player_bodies[current_save.body])
	equipment_list.append(ItemDatabase.player_shields[current_save.shield])
	for e: Equipment in equipment_list:
		stats.max_health += e.extra_health
		stats.speed_bonus += e.speed_bonus
		stats.block_chance += e.block_chance
	return stats

func get_player_weapon() -> Equipment:
	var current_save = SaveManager.get_current_save()
	return ItemDatabase.player_weapons[current_save.weapon]

func get_player_helmet() -> Equipment:
	var current_save = SaveManager.get_current_save()
	return ItemDatabase.player_helmets[current_save.helmet]

func get_player_body() -> Equipment:
	var current_save = SaveManager.get_current_save()
	return ItemDatabase.player_bodies[current_save.body]

func get_player_shield() -> Equipment:
	var current_save = SaveManager.get_current_save()
	return ItemDatabase.player_shields[current_save.shield]
