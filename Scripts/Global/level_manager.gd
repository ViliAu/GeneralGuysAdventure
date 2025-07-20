extends Node

@export var ogre_scene: PackedScene
@export var levels: Array[PackedScene] = []
@export var player_max_dist: int = 120

@export var DEBUG_start_immediately: bool = false
@export var DEBUG_level_to_start: int = 0

@onready var level_parent: Node = $"./Environment"
@onready var entity_parent: Node = $"./Entities"

var loaded_level: Level

func _ready():
	if DEBUG_start_immediately:
		load_level(DEBUG_level_to_start)

func load_level(index: int):
	if index < 0 || index > len(levels):
		return
	clear_level()
	var new_level: Level = levels[index].instantiate()
	level_parent.add_child(new_level)
	new_level.find_child("Player").reparent(entity_parent)
	loaded_level = new_level

	RoundManager.reset_game()

func clear_level():
	for c: Node in level_parent.get_children():
		level_parent.remove_child(c)
		c.queue_free()
	for c: Node in entity_parent.get_children():
		entity_parent.remove_child(c)
		c.queue_free()
	loaded_level = null

func clear_enemies():
	for c: Node in entity_parent.get_children():
		if c is Ogre:
			entity_parent.remove_child(c)
			c.queue_free()

func spawn_ogre() -> Ogre:
	if loaded_level == null:
		return
	var spawn_position: Vector2i = get_spawn_position()
	var ogre: Ogre = ogre_scene.instantiate()
	ogre.position = spawn_position
	entity_parent.add_child(ogre)
	return ogre

func get_spawn_position():
	var nav_tile_positions := loaded_level.nav_tiles.get_used_cells_by_id()
	var spawn_position: Vector2i
	for i in range(0, 1000):
		var spawn_pos_query: Vector2 = nav_tile_positions.pick_random() * 16
		if (spawn_pos_query - entity_parent.find_child("Player", true, false).global_position).length() > player_max_dist:
			spawn_position = spawn_pos_query
			break
	if spawn_position == Vector2i.ZERO:
		print("Could not find spawn position")
	return spawn_position
