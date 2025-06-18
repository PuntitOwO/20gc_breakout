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
@onready var miss_sfx: AudioStreamPlayer = $MissSFX
@onready var win_sfx: AudioStreamPlayer = $WinSFX
@onready var level: TileMapLayer = $Level
var level_template: PackedByteArray

func _ready() -> void:
	ball.brick_broken.connect(_add_score)
	dead_zone.body_entered.connect(_lose_life)
	%HighScore.text = str(high_score)
	_randomize_tile_color.call_deferred()
	level_template = level.tile_map_data

func _add_score() -> void:
	score += 100
	%Score.text = str(score)
	if high_score < score:
		high_score = score
		%HighScore.text = str(high_score)
	if get_tree().get_node_count_in_group("Block") <= 1:
		win_sfx.play()
		level.set_deferred("tile_map_data", level_template)
		await get_tree().physics_frame
		_randomize_tile_color.call_deferred()

func _randomize_tile_color() -> void:
	var colors : Array[Color] = []
	for i in 7: colors.append(Color(randf(),randf(),randf()))
	for node in get_tree().get_nodes_in_group("Block"):
		var block := node as Node2D
		var y := block.global_position.y - 120
		var idx := int(y / 48)
		block.modulate = colors[idx]

func _lose_life(_body: Node2D) -> void:
	lives -= 1
	life_icons[lives].hide()
	if lives > 0:
		paddle.reset()
		miss_sfx.play()
	else:
		get_tree().reload_current_scene.call_deferred()
