extends CharacterBody2D
signal hit
@export var speed = 400
@export var fireball_scene: PackedScene
var screen_size
var last_direction = Vector2.RIGHT 


# Called when the node enters the scene tree for the first time.
func _ready(): 
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Vector2.ZERO 
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		last_direction = velocity.normalized() 
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "Princess"
		$AnimatedSprite2D.flip_v = false
	# See the note below about the following boolean assignment.
		$AnimatedSprite2D.flip_h = velocity.x > 0
	
		
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	if direction.length() > 0:
		velocity = direction.normalized() * speed
		$AnimatedSprite2D.play()
		last_direction = direction.normalized()  # Update last direction when moving
	else:
		velocity = Vector2.ZERO  # Stop movement when no input is detected
		$AnimatedSprite2D.stop()
		
	


func _on_body_entered(body):
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
	

func shoot():
	print("Shoot function called!")  # Debug print
	if fireball_scene:
		var fireball = fireball_scene.instantiate()
		fireball.position = $BulletSpawnPoint.global_position
		fireball.direction = last_direction  
		get_parent().add_child(fireball)  
		print("Fireball spawned at:", fireball.position) 

		
		get_tree().get_root().get_node("Main").add_child(fireball)
