extends Node

var key_count: int = 0

func new_game():
	$Player.start($StartPosition.position)
	key_count = 0  
	update_key_counter()
	
func update_key_counter():
	$KeyCounterLabel.text = "Keys: " + str(key_count)

func _ready() -> void:
	new_game()

func add_key():
	key_count += 1
	update_key_counter()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

	
 
