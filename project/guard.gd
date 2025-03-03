extends CharacterBody2D

@export var speed: float = 50.0  # Guard movement speed
@export var patrol_distance: float = 100.00  # Distance to patrol before turning
@export var patrol_direction: Vector2 = Vector2.RIGHT  # Change to UP, DOWN, LEFT, RIGHT
@export var attack_damage: int = 25  # Damage dealt when colliding with player
@export var attack_cooldown: float = 1.5  # Seconds between attacks

var direction: int = 1  
var start_position: Vector2
var player: CharacterBody2D = null 
var can_attack: bool = true  # Ensures guard attacks only at intervals

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var death_sound = $AudioStreamPlayer2D
@onready var animation_player = $AnimationPlayer 
func _ready():
	start_position = position  # Store initial position

func _physics_process(delta):
	# Move guard back and forth
	if player:  
		var direction_to_player = (player.position - position).normalized()
		velocity = direction_to_player * speed * 1.2
	else:
		velocity = patrol_direction * speed * direction
	# Change direction if out of patrol bounds
	if (position - start_position).length() > patrol_distance:
		direction *= -1  # Reverse direction
		sprite.flip_h = !sprite.flip_h  # Flip sprite horizontally
	var collision = move_and_collide(velocity * delta)
	if collision:  
		direction *= -1
		sprite.flip_h = !sprite.flip_h 
		
func take_damage():
	# Play death sound
	if death_sound:
		death_sound.play()
	
	# Hide the guard and disable collision
	sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	
	get_tree().get_root().get_node("Main").add_key()

	# Free the guard node after the sound finishes
	await death_sound.finished
	queue_free()
func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body  # Store reference to player
		attack_player()  # Start attacking when player is in range

func _on_detection_area_body_exited(body):
	if body == player:
		player = null  # Stop chasing when player leaves area
func attack_player():
	if player and can_attack:
		player.take_damage(attack_damage)  # Call player's damage function
		can_attack = false  # Prevent immediate re-attack
		# ✅ Wait for cooldown before attacking again
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true  # Reset attack availability
