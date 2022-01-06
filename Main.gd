extends Node

export (PackedScene) var Enemy
var score
var hi_score
var is_game_on = false

func _ready():
	randomize()
	$HUD/HiScoreLabel.text= str($"/root/Save".load_game())
	
	# new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_game_on and $HUD/HiScoreLabel.text=="0":
			if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up"):
				$HUD/Instructions.show()

func switch_game_switch():
	is_game_on = !is_game_on
	
	
func game_over():
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$HUD.show_game_over()
	$HUD.check_hi_score()
	$Music.stop()
	$Death.play()
	yield(get_tree().create_timer(2.5), "timeout")
	get_tree().call_group("enemys", "queue_free")
	switch_game_switch()


func new_game():
	$Music.play()
	$EnemyTimer.wait_time=0.5
	score = 0
	hi_score = $HUD/HiScoreLabel.text
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	switch_game_switch()
	


func _on_StartTimer_timeout():
	$EnemyTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout():
	score += 1
	$EnemyTimer.wait_time-=0.001
	$HUD.update_score(score)


func _on_EnemyTimer_timeout():
	# Choose a random location on Path2D.
	$EnemyPath/EnemySpawnLocation.offset = randi()
	# Create a Enemy instance and add it to the scene.
	var enemy = Enemy.instance()
	add_child(enemy)
	# Set the enemy's direction perpendicular to the path direction.
	var direction = $EnemyPath/EnemySpawnLocation.rotation + PI / 2
	# Set the enemy's position to a random location.
	enemy.position = $EnemyPath/EnemySpawnLocation.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	enemy.rotation = direction
	# Set the velocity (speed & direction).
	enemy.linear_velocity = Vector2(rand_range(enemy.min_speed, enemy.max_speed), 0)
	enemy.linear_velocity = enemy.linear_velocity.rotated(direction)
