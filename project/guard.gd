extends CharacterBody2D

@export var speed: float = 50.0  # Guard movement speed
@export var patrol_distance: float = 100.0  # Distance to patrol before turning

var direction: int = 1  # 1 for right, -1 for left
var start_position: Vector2

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var death_sound = $AudioStreamPlayer2D

func _ready():
	start_position = position  # Store initial position

func _physics_process(delta):
	# Move guard back and forth
	position.x += speed * direction * delta
	
	# Change direction if out of patrol bounds
	if abs(position.x - start_position.x) > patrol_distance:
		direction *= -1
		sprite.flip_h = !sprite.flip_h  # Flip the sprite

func take_damage():
	# Play death sound
	if death_sound:
		death_sound.play()
	
	# Hide the guard and disable collision
	sprite.hide()
	collision_shape.set_deferred("disabled", true)
	
	get_tree().get_root().get_node("Main").add_key()

	# Free the guard node after the sound finishes
	await death_sound.finished
	queue_free()
