extends Node

var friendly_soldiers = []
var enemy_soldiers = []

enum {YOU_WIN, YOU_LOSE, PREPARING, FIGHTING, READING, START}
var game_state = PREPARING

func remove_friendly_soldier(soldier):
	var index = friendly_soldiers.find(soldier)
	friendly_soldiers.remove(index)
	
func remove_enemy_soldier(soldier):
	var index = enemy_soldiers.find(soldier)
	enemy_soldiers.remove(index)
	
func reset_game_state():
	game_state = PREPARING

var is_placing_soldier = true

# GUI stuff:
var gui_is_showing = false

var context_text = """
In 262 BC, Rome sends two legions to Sicily, initially willing to negotiate peace 
with the expanding Carthaginian influence in the territory. However, some Roman 
consuls seeking glory, who include Lucius Postumius Megellus and Quintus 
Mamilius Vitulus, pursue conflict with Carthage. Combined the Roman generals 
brought 40,000 men, facing against the sicilian city of Agrigentum with a total 
population of 50,000. The enemy general Hannibal Gisco (not the most famous 
Hannibal), waited in the city not wanting to confront the Roman army. A siege of 
Agrigentum began, forcing the Carthaginians to send Hanno, another general to stop 
the Romans from starving out the city. Some chasing and retreating follows, but the 
Roman army eventually has to face the Carthaginians, leading into the first major 
battle of the First Punic War.
"""

var go_player_text = """
Now dear player, it is your turn to play as the Romans to see if you too can 
defeat the Carthaginians to push them out of Sicily, leaving it to Roman 
control.

To learn more about the battle, visit the really interesting wiki page at:
https://en.wikipedia.org/wiki/Battle_of_Agrigentum#cite_note-Goldsworthy_77-8

Controls:
W S A D to move.
E to summon a new soldier.
Click to place a soldier. 
"""
