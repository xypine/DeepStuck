extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var nature = []
var freeze = false

var player
var currentLevel

var loading = false

# Called when the node enters the scene tree for the first time.
func _ready():
	currentLevel = "res://Scenes/Main.tscn"
	pass # Replace with function body.

func zero():
	freeze = false
	nature = []
func addArm(arm):
	nature.append(arm)
	print("Arm " + str(arm) + " registered")
func rmArm(arm):
	if arm in nature:
		nature.remove( nature.find(arm) )
		print("Arm " + str(arm) + " unregistered")
func setPlayer(playe):
	player = playe
func changeLevel(level, restart=false):
	loading = true
	print("Load Started")
	$LoadPlayer.play("LoadStart")
	yield($LoadPlayer, "animation_finished")
	zero()
	if restart:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene(level)
	$LoadPlayer.play("LoadEnd")
	print("Load Finished.")
	loading = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_retry"):
		changeLevel(currentLevel, true)
	if Input.is_action_just_pressed("ui_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
	if is_instance_valid(player):
		$Sprite.global_position = player.get_child(player.get_children().find("Camera2D"))
		
