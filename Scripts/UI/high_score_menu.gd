extends Control

@export var level1_holder: Control
@export var level2_holder: Control
@export var level3_holder: Control
@export var level4_holder: Control

@export var score_label_scene: PackedScene

func _on_visibility_changed():
	for c: Control in level1_holder.get_children():
		c.queue_free()
	for c: Control in level2_holder.get_children():
		c.queue_free()
	for c: Control in level3_holder.get_children():
		c.queue_free()
	for c: Control in level4_holder.get_children():
		c.queue_free()

	var a: Array = SaveManager.get_all_saves()
	a.sort_custom(sort_l1)
	for s: SaveData in a:
		var s1: ScoreLabel = score_label_scene.instantiate()
		level1_holder.add_child(s1)
		s1.init(s.name, s.level_1_hs)
	a.sort_custom(sort_l2)
	for s: SaveData in a:
		var s1: ScoreLabel = score_label_scene.instantiate()
		level2_holder.add_child(s1)
		s1.init(s.name, s.level_2_hs)
	a.sort_custom(sort_l3)
	for s: SaveData in a:
		var s1: ScoreLabel = score_label_scene.instantiate()
		level3_holder.add_child(s1)
		s1.init(s.name, s.level_3_hs)
	a.sort_custom(sort_l4)
	for s: SaveData in a:
		var s1: ScoreLabel = score_label_scene.instantiate()
		level4_holder.add_child(s1)
		s1.init(s.name, s.level_4_hs)


func sort_l1(s1: SaveData, s2: SaveData):
	if s1.level_1_hs < s2.level_1_hs:
		return true

func sort_l2(s1: SaveData, s2: SaveData):
	if s1.level_1_hs < s2.level_1_hs:
		return true

func sort_l3(s1: SaveData, s2: SaveData):
	if s1.level_1_hs < s2.level_1_hs:
		return true

func sort_l4(s1: SaveData, s2: SaveData):
	if s1.level_1_hs < s2.level_1_hs:
		return true