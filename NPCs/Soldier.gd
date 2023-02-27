extends KinematicBody2D

const SPEED = 800
const ACCELERATION = 1200

var health = 3
var movement_vector = Vector2.ZERO

var is_attacking = false
var is_being_pushed = false
var game_over = false

var attack_target
var next_target

export var enemy_soldier = false
export var is_dead = false

onready var round_start = get_node("../RoundStart")

func _ready():
	if enemy_soldier:
		Global.enemy_soldiers.append(self)
	else:
		Global.friendly_soldiers.append(self)
	
	round_start.connect("new_target", self, "new_target")
	round_start.connect("next_target", self, "next_target")
	round_start.connect("game_over", self, "game_is_over")

func _physics_process(delta):
	if game_over:
		$WalkAnimation.stop()
		return
	
	if is_dead:
		return
	
	if health <= 0:
		die()
		return
	
	if attack_target == null:
		return
	
	if attack_target.is_dead:
		attack_target = next_target
	
	if is_being_pushed:
		get_pushed(delta)
	else:
		move(attack_target.global_position - global_position, delta)

func new_target(attacker, target):
	if attacker != self:
		return
		
	attack_target = target

func next_target(attacker, target):
	if attacker != self:
		return
	
	next_target = target

func game_is_over():
	game_over = true

func move(target: Vector2, delta):
	var target_vector: Vector2 = movement_vector.move_toward(target * SPEED, delta * ACCELERATION)
	
	target_vector = target_vector.rotated(PI / 16)
	
	move_and_slide(target_vector)
	
	$Hurtbox.look_at(target_vector)
	
	if target_vector == Vector2.ZERO:
		$WalkAnimation.stop()
	else:
		$WalkAnimation.play("walk")
	
	# If walking right, face towards the right.
	if target_vector.x >= 0:
		$SoldierTexture.flip_h = false
	# If walking left, face left.
	else:
		$SoldierTexture.flip_h = true

func get_pushed(delta):
	var get_pushed_vec: Vector2 = attack_target.position.normalized() * -40
	
	move_and_slide(get_pushed_vec)

func attack(attack_target: Vector2):
	if is_attacking:
		return
	
	is_attacking = true
	
	$SwordSwipe.look_at(attack_target)
	#$Hurtbox.look_at(attack_target)
	
	# The animation relative to the soldier is by default (-PI / 2) off, just because the animation faces down not right.
	# So this corrects that.
	$SwordSwipe.rotate(PI / 2)
	
	$SwordSwipe.visible = true
	
	$SwingAnimation.play("sword_swing")
	
	$PushedTimer.start(0.1)

func end_of_attack():
	is_attacking = false
	
	$SwordSwipe.hide()

func _on_Hitbox_area_entered(area):
	
	health -= 1
	
	is_being_pushed = true
	
	$PushedTimer.start(0.2)
	
	# Make the soldier red when hit and being pushed.
	$SoldierTexture.modulate.r = 0.86
	$SoldierTexture.modulate.g = 0.11
	$SoldierTexture.modulate.b = 0.11

func _on_Hurtbox_area_entered(area):
	attack(attack_target.global_position)

func _on_PushedTimer_timeout():
	is_being_pushed = false
	
	# Switch the soldiers colors back to normal after being hit.
	$SoldierTexture.modulate.r = 1
	$SoldierTexture.modulate.g = 1
	$SoldierTexture.modulate.b = 1

func die():
	is_dead = true
	
	$SoldierTexture.hide()
	$CollisionShape2D.queue_free()
	$Hitbox.queue_free()
	$Hurtbox.queue_free()
	
	if enemy_soldier:
		Global.remove_enemy_soldier(self)
	else:
		Global.remove_friendly_soldier(self)
