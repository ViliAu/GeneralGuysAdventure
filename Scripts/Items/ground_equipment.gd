class_name GroundEquipment extends Pickupable

@onready var sound: AudioStreamPlayer2D = $"./AudioStreamPlayer2D"

var money_amount: int

var e: Equipment

func init_ground_item(data: Equipment):
	e = data

func _ready():
	sprite.texture = e.texture
	money_amount = e.price
	init_pickupable()

func on_pickup():
	if picked_up:
		return
	super()
	sound.play()
	sprite.texture = null
	sound.finished.connect(queue_free)
