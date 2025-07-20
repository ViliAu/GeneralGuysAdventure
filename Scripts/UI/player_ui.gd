extends Node

@export var wave_label: Label
@export var enemies_left_label: Label
@export var health_bar: ProgressBar
@export var coin_label: Label
@export var death_container: VBoxContainer 
@export var animation_player: AnimationPlayer

@export var money_text_scene: PackedScene

var wave_money = 0
var money_label_offset: Vector2 = Vector2(40, -25)

# Called when the node enters the scene tree for the first time.
func _ready():
	RoundManager.enemies_reduced.connect(update_enemies_left)
	RoundManager.wave_started.connect(update_enemies_left)
	RoundManager.wave_finished.connect(func(): wave_countdown_routine(5))
	RoundManager.money_collected.connect(update_money_text)
	RoundManager.get_player().health_changed.connect(on_player_damage_taken)
	RoundManager.get_player().death.connect(on_player_death)
	RoundManager.get_player().death.connect(on_player_damage_taken)
	wave_money = RoundManager.collected_money

func update_enemies_left():
	enemies_left_label.text = "x %d" % RoundManager.enemies_left

func wave_countdown_routine(timeout: int):
	if timeout == 0:
		wave_label.text = "Wave %d" % RoundManager.wave
		return
	else:
		wave_label.text = "Wave in %d..." % timeout
		var t: Timer = Timer.new()
		t.wait_time = 1
		t.timeout.connect(func(): wave_countdown_routine(timeout-1))
		t.one_shot = true
		add_child(t)
		t.start()

func on_player_damage_taken():
	var ratio: float = int(float(RoundManager.get_player().stats.current_health) / RoundManager.get_player().stats.max_health * 100)
	health_bar.value = ratio

func on_player_death():
	animation_player.play("player_death")

	var wave_counter: Label = death_container.get_child(1)
	var kill_counter: Label = death_container.get_child(2)
	var money_counter: Label = death_container.get_child(3)

	wave_counter.text = "Waves survived: %d" % RoundManager.wave
	kill_counter.text = "Ogres killed: %d" % RoundManager.kills
	money_counter.text = "Ogre coins collected: %d" % RoundManager.collected_money

func update_money_text():
	var collected_money: int = RoundManager.collected_money - wave_money
	var label: Label = money_text_scene.instantiate()
	label.text = "+ %d" % collected_money
	label.global_position = coin_label.global_position + money_label_offset
	add_child(label)
	coin_label.text = "x %d" % RoundManager.collected_money
	wave_money = RoundManager.collected_money

func _on_back_to_menu_button_pressed():
	GameManager.end_game()
