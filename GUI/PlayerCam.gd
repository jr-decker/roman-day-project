extends KinematicBody2D

const CAM_SPEED = 1600
const CAM_ACCELERATION = 8000
const CAM_FRICTION = 800

func _ready():
	pass 

func _process(delta):
	
	var input_vec = Vector2.ZERO
	var player_vec = Vector2.ZERO
	
	input_vec.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vec.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vec = input_vec.normalized()
	
	if input_vec != Vector2.ZERO:
		
		player_vec = player_vec.move_toward(input_vec * CAM_SPEED, delta * CAM_ACCELERATION)
	else:
		
		player_vec = player_vec.move_toward(Vector2.ZERO, delta * CAM_FRICTION)
		
	move_and_slide(player_vec)
