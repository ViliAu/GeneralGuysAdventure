class_name PlayerGraphics extends Node2D

@onready var anim_controller: AnimatedSprite2D = $"./Animation"
@onready var helmet: Sprite2D = $"./Helmet"
@onready var body: Sprite2D = $"./Body"
@onready var shield: Sprite2D = $"./Shield"

@onready var shield_offset = shield.position

var run_speed = 1

func _ready():
	helmet.texture = ItemManager.get_player_helmet().texture
	body.texture = ItemManager.get_player_body().texture
	shield.texture = ItemManager.get_player_shield().texture

# Check if we need to flip graphics
func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	anim_controller.flip_h = mouse_pos.x < global_position.x
	helmet.flip_h = mouse_pos.x < global_position.x
	body.flip_h = mouse_pos.x < global_position.x
	shield.flip_h = mouse_pos.x < global_position.x
	shield.position.x = -shield_offset.x if mouse_pos.x < global_position.x else shield_offset.x

func play_animation(animation: String):
	var anim_speed = 1 if animation == "idle" else run_speed
	anim_controller.play(animation, anim_speed)
