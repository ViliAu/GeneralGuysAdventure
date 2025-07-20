extends Label

@onready var animator: AnimationPlayer = $"./AnimationPlayer"

const SPEED = 40

func _ready():
	var t: Timer = Timer.new()
	t.wait_time = 1
	t.timeout.connect(queue_free)
	t.autostart = true
	add_child(t)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate.a -= 0.5 * delta
	position += Vector2.UP * delta * SPEED