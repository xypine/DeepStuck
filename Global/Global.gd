extends Node2D

const Version = 0.2

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var autosave = "a"
var autosave_nature = "a"
var loadRequested = false
var cutsDone = []

var gravity = 20
var pause = false

var nature = []
var freeze = false

var player
var currentLevel

var loading = false

signal loadFinished

onready var SavePlayer = $SavePlayer
onready var LoadPlayer = $LoadPlayer
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
func changeLevel(level, restart=false, fake=false, old="a"):
	var time_start = OS.get_unix_time()
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
	if str(old) != "a":
		old.queue_free()
	var time_now = OS.get_unix_time()
	print("Level change took " + str(time_now-time_start) + " ms.")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_retry"):
		doLoad()
#		changeLevel(currentLevel, true)
	if Input.is_action_just_pressed("ui_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
	if is_instance_valid(player):
		pass
		
func saveToFile():
	var time_start = OS.get_unix_time()
	var save_game = File.new()
	if save_game.file_exists("user://savegame.save"):
		var dir = Directory.new()
		dir.remove("user://savegame.save.bak")
		dir.rename("user://savegame.save", "user://savegame.save.bak")
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json(autosave))
	save_game.store_line(to_json(autosave_nature))
	save_game.close()
	var time_now = OS.get_unix_time()
	print("Saved progress to savegame.save (" + str(time_now-time_start) + "ms)")
func loadFromFile():
	var time_start = OS.get_unix_time()
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	save_game.open("user://savegame.save", File.READ)
	autosave = parse_json(save_game.get_line())
	autosave_nature = parse_json(save_game.get_line())
	save_game.close()
	var time_now = OS.get_unix_time()
	print("Savegame read from savegame.save succesfull. (" + str(time_now-time_start) + "ms)")

func save():
	var time_start = OS.get_unix_time()
	autosave = player.toDict()
	var nat = []
	for i in nature:
		nat.append(i.toDict())
	autosave_nature = nat
	saveToFile()
	print("Save saved: " + str(Global.autosave))
	var time_now = OS.get_unix_time()
	SavePlayer.play("Saved")

func doLoad():
	var time_start = OS.get_unix_time()
	var time_now = 0
	if str(autosave) != "a" and str(autosave_nature) != "a" and is_instance_valid(autosave):
		player.fromDict(autosave)
		time_now = OS.get_unix_time()
		print("Player loaded in " + str(time_now - time_start) + "ms")
		time_start = OS.get_unix_time()
		var ind = 0
		for i in nature:
			i.fromDict(Global.autosave_nature[ind])
			ind += 1
		print("Player loaded in " + str(time_now - time_start) + "ms")
		time_now = OS.get_unix_time()
		print("A.R.M.s loaded in " + str(time_now - time_start) + "ms")
		SavePlayer.play("Loaded")
	else:
		print("No valid savedata avaible")
		SavePlayer.play("Load Failed")
