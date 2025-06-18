class_name Paddle
extends CharacterBody2D

@onready var ball: Ball = $"../Ball"
@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D
var initial_position :Vector2
var holding_ball := true
const SPEED := 500

func _ready() -> void:
	initial_position = global_position
	ball.set_physics_process(false)

func _physics_process(_delta: float) -> void:
	velocity.x = Input.get_axis("left", "right") * SPEED
	move_and_slide()
	# Y coordinate fixing
	global_position.y = initial_position.y

	if not holding_ball: return
	if Input.is_action_just_pressed("launch"):
		holding_ball = false
		remote_transform_2d.update_position = false
		ball.set_physics_process(true)
		ball.compute_initial_velocity()

func reset() -> void:
	global_position = initial_position
	remote_transform_2d.update_position = true
	holding_ball = true
	ball.set_physics_process(false)
