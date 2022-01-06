extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const filepath = "user://savegame.save"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	var saved_game_file = File.new()
	if not saved_game_file.file_exists("user://savegame.save"):
		return 0
	saved_game_file.open(filepath, File.READ)
	var hi_score = saved_game_file.get_var()
	saved_game_file.close()
	return hi_score if hi_score else 0



func save_game(hi_score):
	var saved_game_file = File.new()
	saved_game_file.open(filepath, File.WRITE)
	saved_game_file.store_var(hi_score)
	
	saved_game_file.close()
	
