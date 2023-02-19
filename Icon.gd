extends Sprite

func _ready():
	
	$Timer.start(5.0)


func _OnTimerEnd():
	
	hide() # Hides the Icon
