extends Node2D

const Version = 0.1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var autosave = "a"
var autosave_nature = "a"
var loadRequested = false
var cutsDone = []

var nature = []
var freeze = false

var player
var currentLevel

var loading = false

signal loadFinished

onready var SavePlayer = $SavePlayer
var notfirst = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("DeepStuck v. " + str(Version) + " by Jonnelafin")
	print("Please report bugs to https://github.com/jonnelafin/DeepStuck or send email to elias.eskelinen@pm.me")
	print("-----")
	print("Starting game.")
	currentLevel = "res://Scenes/Main.tscn"
	loadFromFile()
	pass # Replace with function body.
func zeroProgress():
	autosave = "a"
	autosave_nature = "a"
	loadRequested = false
	cutsDone = []
	zero()
func zero():
	freeze = false
	nature = []
	cutsDone = []
func addArm(arm):
	nature.append(arm)
	print("Arm " + str(arm) + " registered")
func rmArm(arm):
	if arm in nature:
		nature.remove( nature.find(arm) )
		print("Arm " + str(arm) + " unregistered")
func setPlayer(playe):
	player = playe
func changeLevel(level, restart=false, fake=false):
	loading = true
	print("Load Started")
	$LoadPlayer.play("LoadStart")
	yield($LoadPlayer, "animation_finished")
	if not fake:
		zero()
		if restart:
			get_tree().reload_current_scene()
		else:
			get_tree().change_scene(level)
	$LoadPlayer.play("LoadEnd")
	print("Load Finished.")
	loading = false
	emit_signal("loadFinished")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_retry"):
		changeLevel(currentLevel, true)
	if Input.is_action_just_pressed("ui_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
	if is_instance_valid(player):
		pass
		
func saveToFile():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json(autosave))
	save_game.store_line(to_json(autosave_nature))
	save_game.close()
	print("Saved progress to savegame.save")
func loadFromFile():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)
	autosave = parse_json(save_game.get_line())
	autosave_nature = parse_json(save_game.get_line())
	save_game.close()
	print("Savegame read from savegame.save succesfull.")
