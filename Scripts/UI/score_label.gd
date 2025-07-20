class_name ScoreLabel extends Panel

@export var user_label: Label
@export var score_label: Label

func init(user: String, score: int):
	user_label.text = user
	score_label.text = str(score)
