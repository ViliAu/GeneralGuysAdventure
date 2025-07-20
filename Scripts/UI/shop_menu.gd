extends Node

@export var base_stats: PlayerStats
@export var check_mark: Texture2D
@export var shop_container: HBoxContainer
@export var coin_label: Label

#@onready var helmet_container = $"./MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/HelmetContainer/HelmetBuyButton/VBoxContainer"
#@onready var body_container = $"./MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/BodyContainer/BodyBuyButton/VBoxContainer"
#@onready var shield_container = $"./MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/ShieldContainer/ShieldBuyButton/VBoxContainer"
#@onready var weapon_container = $"./MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/WeaponContainer/WeaponBuyButton/VBoxContainer"

var stats_with_items: PlayerStats
var weapon_stats: Equipment

func _on_visibility_changed():
	reload_shop()

func reload_shop():
	stats_with_items = base_stats.duplicate()
	var item_stats = ItemManager.get_stats_from_player_items()
	stats_with_items.max_health += item_stats.max_health
	stats_with_items.speed_bonus += item_stats.speed_bonus
	stats_with_items.block_chance += item_stats.block_chance
	weapon_stats = ItemManager.get_player_weapon()
	var save: SaveData = SaveManager.get_current_save()

	# setup label settings
	var equipment_levels: Array[int] = [save.helmet, save.body, save.shield, save.weapon]
	for i: int in range(0, len(equipment_levels)):
		var current_item_index = i
		var current_item_level = equipment_levels[i]
		var shop_parent: VBoxContainer = shop_container.get_child(i).get_child(0).get_child(0)
		var rect: TextureRect = shop_parent.get_child(0)
		var price_label: Label = shop_parent.get_child(1)
		var level_label: Label = shop_parent.get_child(2)
		var stats_label: RichTextLabel = shop_parent.get_child(3)
		if current_item_level == 4:
			rect.texture = check_mark
			price_label.text = "MAXED"
			level_label.text = "Level: MAXED"
			stats_label.text = "Speed bonus: %d" % stats_with_items.speed_bonus if current_item_index == 0 \
				else "Max Health: %d" % stats_with_items.max_health  if current_item_index == 1 \
				else "Block chance: %.2f" % stats_with_items.block_chance  if current_item_index == 2 \
				else "%d dmg / %.1fs " % [weapon_stats.extra_damage, weapon_stats.swing_speed]
			pass
		else:
			match current_item_index:
				0: #HELMET
					var e: Equipment = ItemDatabase.player_helmets[current_item_level + 1]
					rect.texture = e.texture
					price_label.text = "Price: " + str(e.price)
					level_label.text = "Level: " + str(current_item_level + 2)
					stats_label.text = "Movement speed: %d -> %d" % [stats_with_items.speed_bonus, stats_with_items.speed_bonus + e.speed_bonus]
				1: #BODY
					var e: Equipment = ItemDatabase.player_bodies[current_item_level + 1]
					rect.texture = e.texture
					price_label.text = "Price: " + str(e.price)
					level_label.text = "Level: " + str(current_item_level + 2)
					stats_label.text = "Max health: %d -> %d" % [stats_with_items.max_health, stats_with_items.max_health + e.extra_health]
				2: #SHIELD
					var e: Equipment = ItemDatabase.player_shields[current_item_level + 1]
					rect.texture = e.texture
					price_label.text = "Price: " + str(e.price)
					level_label.text = "Level: " + str(current_item_level + 2)
					stats_label.text = "Block chance: %.2f -> %.2f" % [stats_with_items.block_chance, stats_with_items.block_chance + e.block_chance]
				3: #WEAPON
					var e: Equipment = ItemDatabase.player_weapons[current_item_level + 1]
					rect.texture = e.texture
					price_label.text = "Price: " + str(e.price)
					level_label.text = "Level: " + str(current_item_level + 2)
					stats_label.text = "%d dmg / %.1fs: -> %d dmg / %.1fs" % [weapon_stats.extra_damage, weapon_stats.swing_speed, \
																			e.extra_damage, e.swing_speed]
		coin_label.text = "x %d" % save.money
				
		
		

func _on_helmet_buy_button_pressed():
	if (SaveManager.get_current_save().helmet == 4):
		return
	elif (SaveManager.get_current_save().money >= ItemDatabase.player_helmets[SaveManager.get_current_save().helmet+1].price):
		SaveManager.get_current_save().money -= ItemDatabase.player_helmets[SaveManager.get_current_save().helmet+1].price
		SaveManager.get_current_save().helmet += 1
		SaveManager.save_current()
		reload_shop()

func _on_body_buy_button_pressed():
	if (SaveManager.get_current_save().body == 4):
		return
	elif (SaveManager.get_current_save().money >= ItemDatabase.player_bodies[SaveManager.get_current_save().body+1].price):
		SaveManager.get_current_save().money -= ItemDatabase.player_bodies[SaveManager.get_current_save().body+1].price
		SaveManager.get_current_save().body += 1
		SaveManager.save_current()
		reload_shop()

func _on_shield_buy_button_pressed():
	if (SaveManager.get_current_save().shield == 4):
		return
	elif (SaveManager.get_current_save().money >= ItemDatabase.player_shields[SaveManager.get_current_save().shield+1].price):
		SaveManager.get_current_save().money -= ItemDatabase.player_shields[SaveManager.get_current_save().shield+1].price
		SaveManager.get_current_save().shield += 1
		SaveManager.save_current()
		reload_shop()

func _on_weapon_buy_button_pressed():
	if (SaveManager.get_current_save().weapon == 4):
		return
	elif (SaveManager.get_current_save().money >= ItemDatabase.player_weapons[SaveManager.get_current_save().weapon+1].price):
		SaveManager.get_current_save().money -= ItemDatabase.player_weapons[SaveManager.get_current_save().weapon+1].price
		SaveManager.get_current_save().weapon += 1
		SaveManager.save_current()
		reload_shop()
