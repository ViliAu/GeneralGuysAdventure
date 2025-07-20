class_name Ogre extends CharacterBody2D

signal on_death

@export var base_stats: OgreStats
@export var ground_equipment_scene: PackedScene
@export var potion_scene: PackedScene

@onready var helmet_sprite: Sprite2D = $"./Graphics/Helmet"
@onready var body_sprite: Sprite2D = $"./Graphics/Body"
@onready var shield_sprite: Sprite2D = $"./Graphics/Shield"
@onready var weapon_sprite: Sprite2D = $"./Graphics/Weapon"
@onready var agent: NavigationAgent2D = $"./NavigationAgent2D"
@onready var hit_area: Area2D = $"./HitArea"
@onready var animation: AnimatedSprite2D = $"./Graphics/Animation"
@onready var controller: AnimationPlayer = $"./Controller"

var stats: OgreStats
var target_vector := Vector2.ZERO

const agent_interval := 0.1
const money_per_kill = 1

var dead = false

var timer = Timer.new()

var equipment_list: Array[Equipment]

var knockback: Vector2 = Vector2.ZERO

func _ready():
	parse_equipment_stats()
	initialize_agent()
	animation.play("default")

func parse_equipment_stats():
	var helmeti = RoundManager.get_equipment_difficulty()
	var bodyi = RoundManager.get_equipment_difficulty()
	var shieldi = RoundManager.get_equipment_difficulty()
	var weaponi = RoundManager.get_equipment_difficulty()

	var helmet: Equipment = null if helmeti == 0 else ItemDatabase.ogre_helmets[helmeti - 1]
	var body: Equipment = null if bodyi == 0 else ItemDatabase.ogre_bodies[bodyi - 1]
	var shield: Equipment = null if shieldi == 0 else ItemDatabase.ogre_shields[shieldi - 1]
	var weapon: Equipment = null if weaponi == 0 else ItemDatabase.ogre_weapons[weaponi - 1]
	equipment_list = [helmet, body, shield, weapon]
	stats = OgreStats.new()
	for e: Equipment in equipment_list:
		if e == null:
			continue
		stats.max_health += e.extra_health
		stats.damage += e.extra_damage
		stats.speed_bonus += e.speed_bonus
		stats.knockback_resist += e.knockback_resist
	stats.max_health += base_stats.max_health
	stats.damage += base_stats.damage
	stats.speed_bonus += base_stats.speed_bonus
	stats.knockback_resist += base_stats.knockback_resist
	helmet_sprite.texture = helmet.texture if helmet != null else null
	body_sprite.texture = body.texture if body != null else null
	shield_sprite.texture = shield.texture if shield != null else null
	weapon_sprite.texture = weapon.texture if weapon != null else null
	stats.health = stats.max_health

func initialize_agent():
	timer.one_shot = false
	timer.autostart = true
	timer.wait_time = agent_interval
	timer.timeout.connect(calculate_new_agent_position)
	timer.timeout.connect(check_overlapping_bodies)
	add_child(timer)

func calculate_new_agent_position():
	if RoundManager.get_player() == null:
		return
	agent.target_position = RoundManager.get_player().global_position
	var target_pos = agent.get_next_path_position()
	target_vector = global_position.direction_to(target_pos)

func check_overlapping_bodies():
	var overlapping_bodies = hit_area.get_overlapping_bodies()
	for b in overlapping_bodies:
		if b is Player:
			b.take_damage(stats.damage)

func _physics_process(_delta):
	if dead:
		return
	velocity = target_vector * stats.speed_bonus + knockback
	move_and_slide()
	knockback = lerp(knockback, Vector2.ZERO, 0.1)

func take_damage(dmg: int, kb: Vector2):
	controller.play("damage")
	stats.health -= dmg
	if stats.health <= 0:
		die()
	knockback = kb * (1 - stats.knockback_resist)

func die():
	controller.play("die")
	dead = true
	timer.stop()
	target_vector = global_position
	on_death.emit()

	# drop stuff
	var p: HealthPotion = potion_scene.instantiate()
	p.global_position = global_position
	LevelManager.entity_parent.add_child(p)
	for e: Equipment in equipment_list:
		if e == null:
			continue
		var ge: GroundEquipment = ground_equipment_scene.instantiate()
		ge.init_ground_item(e)
		ge.global_position = global_position
		LevelManager.entity_parent.add_child(ge)
	RoundManager.on_money_collected(money_per_kill)
