#extends Area2D
#
#var speed = 400  # Speed of the fireball
#
#func _ready():
	## Make the fireball move in the direction it's facing (e.g., right)
	#set_linear_velocity(Vector2(speed, 0))
#
#func set_linear_velocity(velocity: Vector2):
	#$Sprite.rotation = velocity.angle()
	#$CollisionShape2D.position += velocity * delta



extends Area2D

@export var speed: float = 600
var direction: Vector2 = Vector2.ZERO 


func _process(delta):
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta 

func fireball(body: Node2D) -> void:
	pass 


func _on_area_entered(area: Area2D) -> void:
	pass 

func _on_body_entered(body):
	if body.is_in_group("guard"):  # Make sure the guard is in the "guard" group
		body.take_damage()
		queue_free()  # Destroy the power ball
