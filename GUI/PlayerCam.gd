extends KinematicBody2D

const SPEED = 8000
const ACCELERATION = 9000

var input_vector: Vector2 = Vector2.ZERO
var movement_vector: Vector2 = Vector2.ZERO

func _ready():
	pass 

func _process(delta):
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		
		movement_vector = movement_vector.move_toward(input_vector * SPEED, delta * ACCELERATION)
	else:
		
		movement_vector = movement_vector.move_toward(Vector2.ZERO, delta * ACCELERATION)
		
	move_and_slide(movement_vector)
