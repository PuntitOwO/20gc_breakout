extends Node2D

var lives := 3
var score := 0
static var high_score := 0

@onready var paddle := $Paddle as Paddle
@onready var ball := $Ball as Ball
@onready var dead_zone := $DeadZone as Area2D
@onready var life_icons: Array[Control] = [
	$UI/MarginContainer/MarginContainer/VBoxContainer/LifeIcon,
	$UI/MarginContainer/MarginContainer/VBoxContainer/LifeIcon2,
	$UI/MarginContainer/MarginContainer/VBoxContainer/LifeIcon3
]

func _ready() -> void:
	ball.brick_broken.connect(_add_score)
	dead_zone.body_entered.connect(_lose_life)
	%HighScore.text = str(high_score)

func _add_score() -> void:
	score += 100
	%Score.text = str(score)
	if high_score < score:
		high_score = score
		%HighScore.text = str(high_score)

func _lose_life(_body: Node2D) -> void:
	lives -= 1
	life_icons[lives].hide()
	if lives > 0:
		paddle.reset()
	else:
		get_tree().reload_current_scene.call_deferred()
