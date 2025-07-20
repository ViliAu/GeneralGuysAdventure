class_name HealthPotion extends Pickupable

@export var potion_sprites: Array[Texture2D]
@export var healing_amounts = [1, 2, 4, 7]

@onready var sound: AudioStreamPlayer2D = $"./AudioStreamPlayer2D"

const MEAN = 0
const SD = 2

var healing_amount = 0

func _ready():
	var rng = RandomNumberGenerator.new()
	var roll = int(rng.randfn(MEAN, SD))
	print(roll)
	if roll < 0 || roll >= len(potion_sprites):
		queue_free()
		return
	sprite.texture = potion_sprites[roll]
	healing_amount = healing_amounts[roll]
	init_pickupable()

func on_pickup():
	if picked_up:
		return
	super()
	sprite.texture = null
	sound.play()
	sound.finished.connect(queue_free)
