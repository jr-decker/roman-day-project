extends KinematicBody2D

const SPEED = 800
const ACCELERATION = 1200

var movement_vector: Vector2 = Vector2.ZERO
var is_attacking: bool = false

func _ready():
	pass 


func _process(delta):
	
	var target = get_global_mouse_position()
	
	Move(target - global_position, delta)
	Attack(target)

func Move(target: Vector2, delta):
	
	var target_vector: Vector2 = movement_vector.move_toward(target * SPEED, delta * ACCELERATION)
	
	move_and_slide(target_vector)
	
	if target_vector != Vector2.ZERO:
		$WalkAnimation.play("walk")
	
	# If walking right, face towards the right.
	if target_vector.x >= 0:
		$SoldierTexture.flip_h = false
	# If walking left, face left.
	else:
		$SoldierTexture.flip_h = true
		
func Attack(attack_target: Vector2):
	
	if is_attacking:
		return
	
	is_attacking = true
	
	$SwordSwipe.look_at(attack_target)
	
	# The animation relative to the soldier is by default (-PI / 2) off, just because the animation faces down not right.
	# So this corrects that.
	$SwordSwipe.rotate(PI / 2)
	
	$SwordSwipe.visible = true
	
	$SwingAnimation.play("sword_swing")
	
func EndOfAttack():
	
	is_attacking = false
	$SwordSwipe.hide()
