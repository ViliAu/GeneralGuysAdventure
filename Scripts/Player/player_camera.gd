extends Node2D

@export var SPEED = 0.4

@onready var player_body: Node2D = get_parent().find_children("*", "Player", true, false) as Array[Player][0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var target = player_body.global_position
	global_position = global_position.lerp(target, SPEED)
