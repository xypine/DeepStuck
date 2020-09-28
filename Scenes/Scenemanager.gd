extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if str(Global.autosave) != "a" and Global.loadRequested:
		Global.loadRequested = false
		Global.doLoad()
	print(str(len(Global.nature)) + " A.R.M.s loaded.")
	pass # Replace with function body.

var save1
var flag = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Global.save()
		Global.changeLevel("res://Scenes/Menu/Menu.tscn", false, false, self)
	if is_instance_valid(Global.player):
		if Global.player.global_position.y > 2000:
			Global.player.global_position.y = 2000
			if not flag:
				flag = true
				Global.LoadPlayer.play("LoadStart")
				yield(Global.LoadPlayer, "animation_finished")
				Global.doLoad()
				Global.LoadPlayer.play("LoadEnd")
				flag = false

