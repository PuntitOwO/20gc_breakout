class_name Ball
extends CharacterBody2D

signal brick_broken

const INITIAL_SPEED := 200
var speed := 200
var acceleration_delta := 8

@onready var collision_sfx: AudioStreamPlayer = $CollisionSFX

func _ready() -> void:
	compute_initial_velocity()

func compute_initial_velocity() -> void:
	speed = INITIAL_SPEED
	velocity = Vector2.UP * speed

func _physics_process(delta: float) -> void:
	velocity = velocity.normalized() * speed
	var collision := move_and_collide(velocity * delta)
	if collision == null: return
	collision_sfx.play()
	velocity = velocity.bounce(collision.get_normal())
	var collider := collision.get_collider() as Node2D
	if collider.is_in_group("Block"):
		collider.queue_free()
		speed += acceleration_delta
		brick_broken.emit()
