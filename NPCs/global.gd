extends Node

var friendly_soldiers = []
var enemy_soldiers = []

enum {YOU_WIN, YOU_LOSE, TIE, FIGHTING}
var game_state = FIGHTING

func remove_friendly_soldier(soldier):
	var index = friendly_soldiers.find(soldier)
	friendly_soldiers.remove(index)
	
func remove_enemy_soldier(soldier):
	var index = enemy_soldiers.find(soldier)
	enemy_soldiers.remove(index)
