extends Node2D

@export var enabled = true

@onready var controller: AnimationPlayer = $"./Controller"
@onready var weapon_area: Area2D = $"./PlayerWeapon"
@onready var weapon_area_shape: CollisionShape2D = $"./PlayerWeapon/CollisionShape2D"
@onready var weapon_graphics: Sprite2D = $"./PlayerWeapon/Sprite2D"
@onready var audio_player: AudioStreamPlayer2D = $"./Weaponaudio"

var current_weapon: Equipment
var last_attack: int = 0

var hit_enemies: Array[Ogre] = []

const knockback_variance_deg = 20
const knockback_force = 80

# TODO Init from save
func _ready():
	controller.play("RESET")

	current_weapon = ItemManager.get_player_weapon()
	weapon_graphics.texture = current_weapon.texture

func _process(_delta):
	if !enabled:
		return
	rotate_sprite()

	if Input.is_action_pressed("Attack"):
		handle_attack()
	
	if !weapon_area_shape.disabled:
		check_weapon_overlap()

# func _input(event):
# 	event.

func rotate_sprite():
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)

	scale.x = -1 if mouse_pos.x < get_parent().global_position.x else 1
	rotation_degrees = rotation_degrees - 180 if mouse_pos.x < get_parent().global_position.x else rotation_degrees

func handle_attack():
	if Time.get_ticks_msec() < last_attack + int(current_weapon.swing_speed * 1000):
		return
	hit_enemies = []
	last_attack = Time.get_ticks_msec()
	audio_player.play()
	controller.play("attack")
	
func check_weapon_overlap():
	var swing_enemies = weapon_area.get_overlapping_bodies()

	for e in swing_enemies:
		if e not in hit_enemies:
			var knockback_vec = (RoundManager.get_player().global_position.direction_to(e.global_position).rotated(deg_to_rad(-knockback_variance_deg + randf() \
				* knockback_variance_deg * 2)) \
				* knockback_force)
			hit_enemies.append(e)
			e.take_damage(current_weapon.extra_damage, knockback_vec)
