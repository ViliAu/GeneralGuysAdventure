class_name Player extends CharacterBody2D

signal health_changed
signal death

@export var base_stats: PlayerStats = null
@export var enabled = true
@export var can_hit = true

@onready var animator: PlayerGraphics = find_children("*", "PlayerGraphics", true, false) as Array[PlayerGraphics][0]
@onready var controller: AnimationPlayer = $"./Controller"
@onready var pickup_area: Area2D = $"./PickupArea"
@onready var collider: CollisionShape2D = $"./CollisionShape2D"

var stats: PlayerStats

var current_save: SaveData = null

# Initialize stats from items
func _ready():
	stats = base_stats.duplicate()
	var item_stats = ItemManager.get_stats_from_player_items()
	stats.max_health += item_stats.max_health
	stats.speed_bonus += item_stats.speed_bonus
	stats.block_chance += item_stats.block_chance
	stats.current_health = stats.max_health

	current_save = SaveManager.get_current_save()
	controller.animation_finished.connect(clear_anim)

func _physics_process(_delta):
	if !enabled:
		return

	check_pickupables()
	
	var direction = Vector2(int(Input.is_physical_key_pressed(current_save.move_right_input)) - int(Input.is_physical_key_pressed(current_save.move_left_input)), \
							int(Input.is_physical_key_pressed(current_save.move_down_input)) - int(Input.is_physical_key_pressed(current_save.move_up_input))).normalized()
	if direction:
		velocity = direction * stats.speed_bonus
		animator.play_animation("run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, stats.speed_bonus)
		animator.play_animation("idle")

	move_and_slide()

func check_pickupables():
	var items := pickup_area.get_overlapping_areas()
	for item in items:
		if item is GroundEquipment:
			RoundManager.on_money_collected(item.money_amount)
			item.on_pickup()
		elif item is HealthPotion:
			if stats.current_health >= stats.max_health:
				continue
			heal(item.healing_amount)
			item.on_pickup()

func take_damage(amount: int):
	if !can_hit:
		return
	var rng = RandomNumberGenerator.new().randf()
	if rng < stats.block_chance:
		controller.play("block")
		return
	stats.current_health -= amount
	if stats.current_health <= 0:
		die()
	else:
		controller.play("iframes")
		health_changed.emit()

func heal(amount: int):
	if stats.current_health >= stats.max_health:
		return
	stats.current_health = clamp(stats.current_health + amount, 0, stats.max_health)
	#controller.play("heal")
	health_changed.emit()

func die():
	controller.play("death")
	death.emit()
	RoundManager.on_player_death()

func clear_anim(_anim):
	if stats.current_health >= 0:
		animator.visible = true
		collider.disabled = false
