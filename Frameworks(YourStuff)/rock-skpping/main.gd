extends Game
@onready var rock: RigidBody2D = $ROCK
 
func _start_game():
	Engine.time_scale = clamp(get_intensity(), 1.0, 1.8)
