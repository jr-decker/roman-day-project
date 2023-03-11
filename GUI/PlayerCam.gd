extends KinematicBody2D

const SPEED = 100 
const ACCELERATION = 4000

var input_vector: Vector2 = Vector2.ZERO
var movement_vector: Vector2 = Vector2.ZERO\

var preload_soldier = preload("res://NPCs/FriendlySoldier.tscn")

signal reset

func _ready():
	pass

func _physics_process(delta):
	
	# Move the camera:
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		
		movement_vector = movement_vector.move_toward(input_vector * SPEED, delta * ACCELERATION)
	else:
		
		movement_vector = movement_vector.move_toward(Vector2.ZERO, delta * ACCELERATION)
		
	move_and_slide(movement_vector)
	
	# Rest is GUI:
	if Global.gui_is_showing:
		$ColorRect.visible = true
		$LoreLabel.visible = true
	else:
		$ColorRect.visible = false
		$LoreLabel.visible = false
		
	if $LoreLabel.visible && $LoreLabel.text == Global.context_text:
		$NextButton.visible = true
	else:
		$NextButton.visible = false
		
	if Global.game_state == Global.YOU_WIN:
		$GameStateLabel.text = "You Win!"
		$GameStateLabel.visible = true
		
		$ResetButton.visible = true
	elif Global.game_state == Global.YOU_LOSE:
		$GameStateLabel.text = "You Lose!"
		$GameStateLabel.visible = true
		
		$ResetButton.visible = true
	else:
		$GameStateLabel.visible = false
		$ResetButton.visible = false

func _on_LoreButton_pressed():
	# Reverse whether it is or isnt showing.
	Global.gui_is_showing = !Global.gui_is_showing
	$LoreLabel.text = Global.context_text

func _on_NextButton_pressed():
	$LoreLabel.text = Global.go_player_text
	
func _on_StartButton_pressed():
	if Global.game_state == Global.FIGHTING:
		return
	
	Global.game_state = Global.START

func _input(event):
	if (event.is_action_pressed("ui_place")) && (!Global.is_placing_soldier) && (Global.game_state == Global.PREPARING):
		var new_soldier = preload_soldier.instance()
		
		get_parent().get_node("Soldiers").add_child(new_soldier)

func _on_ResetButton_pressed():
	Global.reset_game_state()
	emit_signal("reset")
