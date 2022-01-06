extends CanvasLayer

signal start_game
# Called when the node enters the scene tree for the first time.
func _ready():
	$Instructions.hide()
	pass
func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func check_hi_score(): 
	var hi_score = $HiScoreLabel.text
	var new_score = $ScoreLabel.text
	
	if int(new_score)>int(hi_score):
		$"/root/Save".save_game(int(new_score))
		$HiScoreLabel.text = $ScoreLabel.text
		$Message.text = "New Hi-Score!"
		$Message.show()
		var color1 = $Message.get_color("font_color")
		var color2 = Color.darkred
		for i in range(20):
			if i%2==0:
				$Message.add_color_override("font_color",color2)
			else:
				$Message.add_color_override("font_color",color1)
				
			yield(get_tree().create_timer(0.1), "timeout")
		
func show_game_over():
	show_message("Game Over")
	
	
	# Wait until the MessageTimer has counted down.
	yield($MessageTimer, "timeout")
	
	$Message.text = "Use Arrows to move"
	$Message.show()
	
	# Make a one-shot timer and wait for it to finish.
	yield(get_tree().create_timer(1), "timeout")
	$StartButton.show()
	$ScoreLabel.hide()


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_MessageTimer_timeout():
	$Message.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	$ScoreLabel.show()
	$Instructions.hide()
	emit_signal("start_game")
