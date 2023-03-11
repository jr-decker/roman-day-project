extends Node

signal new_target(attacker, target)  # Gives every soldier a target at the beginning of the round.
signal next_target(attacker, target) # Updates a potensial next target for every soldier every physics tick.

signal reset

func _ready():
	pass
	
func _on_GameTimer_timeout():
# warning-ignore:unsafe_property_access
	for friendly_soldier in Global.friendly_soldiers:
# warning-ignore:unsafe_property_access
		Global.enemy_soldiers.shuffle()
# warning-ignore:unsafe_property_access
		var random_enemy = Global.enemy_soldiers.front()
		
		emit_signal("new_target", friendly_soldier, random_enemy)
		
# warning-ignore:unsafe_property_access
	for enemy_soldier in Global.enemy_soldiers:
# warning-ignore:unsafe_property_access
		Global.friendly_soldiers.shuffle()
# warning-ignore:unsafe_property_access
		var random_friendly = Global.friendly_soldiers.front()
		
		emit_signal("new_target", enemy_soldier, random_friendly)

# warning-ignore:unused_argument
func _physics_process(delta):
# warning-ignore:unsafe_method_access
# warning-ignore:unsafe_property_access
# warning-ignore:unsafe_method_access
	if ($GameTimer.is_stopped()) && (Global.game_state == Global.START):
		$GameTimer.start(1)
# warning-ignore:unsafe_property_access
		Global.game_state = Global.FIGHTING
	
# warning-ignore:unsafe_method_access
	if !$GameTimer.is_stopped():
		return
	
# warning-ignore:unsafe_property_access
	if Global.game_state != Global.FIGHTING:
		return
	
# warning-ignore:unsafe_property_access
	if Global.friendly_soldiers.empty():
# warning-ignore:unsafe_property_access
		Global.game_state = Global.YOU_LOSE
		return
		
# warning-ignore:unsafe_property_access
	if Global.enemy_soldiers.empty():
# warning-ignore:unsafe_property_access
		Global.game_state = Global.YOU_WIN
		return
	
# warning-ignore:unsafe_property_access
	for friendly_soldier in Global.friendly_soldiers:
# warning-ignore:unsafe_property_access
		Global.enemy_soldiers.shuffle()
# warning-ignore:unsafe_property_access
		var random_enemy = Global.enemy_soldiers.front()
		
		emit_signal("next_target", friendly_soldier, random_enemy)
		
# warning-ignore:unsafe_property_access
	for enemy_soldier in Global.enemy_soldiers:
# warning-ignore:unsafe_property_access
		Global.friendly_soldiers.shuffle()
# warning-ignore:unsafe_property_access
		var random_friendly = Global.friendly_soldiers.front()
		
		emit_signal("next_target", enemy_soldier, random_friendly)

func _on_PlayerCam_reset():
	emit_signal("reset")
