extends Area2D

@export var heal_amount: int = 20  # Amount of health restored

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):  # Ensure player can collect the potion
		body.restore_health(heal_amount)
		queue_free()  # Remove potion after collection
