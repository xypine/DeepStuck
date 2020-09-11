extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var flag = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Global.changeLevel("res://Scenes/Menu/Menu.tscn")
	if is_instance_valid(Global.player):
		if Global.player.global_position.y > 2000:
			Global.player.global_position.y = 2000
			if not flag:
				flag = true
				Global.changeLevel("", true)
