class_name Pickupable extends Area2D

@onready var sprite: Sprite2D = $"./Sprite2D"
@onready var collision: CollisionShape2D = $"./CollisionShape2D"

var velocity = Vector2.UP
var MAX_SPEED = 4

const DECEL = 0.55

var picked_up = false

func init_pickupable():
	collision.disabled = true
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	var dir: int = rng.randi() % 360
	var speed: int = rng.randi() % 40
	velocity = Vector2.UP.rotated(deg_to_rad(dir)) * speed
	var t: Timer = Timer.new()
	t.wait_time = 0.5
	t.timeout.connect(func(): collision.disabled = false)
	t.autostart = true
	t.one_shot = true
	add_child(t)

func _physics_process(_delta):
	velocity = velocity.lerp(Vector2.ZERO, DECEL)
	global_position += velocity

func on_pickup():
	picked_up = true
	collision.disabled = true