extends Node

signal new_target(attacker, target)  # Gives every soldier a target at the beginning of the round.
signal next_target(attacker, target) # Updates a potensial next target for every soldier every physics tick.
signal game_over

func _on_GameTimer_timeout():
	for friendly_soldier in Global.friendly_soldiers:
		Global.enemy_soldiers.shuffle()
		var random_enemy = Global.enemy_soldiers.front()
		
		emit_signal("new_target", friendly_soldier, random_enemy)
		
	for enemy_soldier in Global.enemy_soldiers:
		Global.friendly_soldiers.shuffle()
		var random_friendly = Global.friendly_soldiers.front()
		
		emit_signal("new_target", enemy_soldier, random_friendly)

func _physics_process(delta):
	if !$GameTimer.is_stopped():
		return
	
	if Global.game_state != Global.FIGHTING:
		return
	
	if Global.friendly_soldiers.empty() && Global.enemy_soldiers.empty():
		Global.game_state = Global.TIE
		emit_signal("game_over")
		return
	
	if Global.friendly_soldiers.empty():
		Global.game_state = Global.YOU_LOSE
		emit_signal("game_over")
		return
		
	if Global.enemy_soldiers.empty():
		Global.game_state = Global.YOU_WIN
		emit_signal("game_over")
		return
	
	for friendly_soldier in Global.friendly_soldiers:
		Global.enemy_soldiers.shuffle()
		var random_enemy = Global.enemy_soldiers.front()
		
		emit_signal("next_target", friendly_soldier, random_enemy)
		
	for enemy_soldier in Global.enemy_soldiers:
		Global.friendly_soldiers.shuffle()
		var random_friendly = Global.friendly_soldiers.front()
		
		emit_signal("next_target", enemy_soldier, random_friendly)
