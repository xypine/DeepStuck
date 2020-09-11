extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.currentLevel = "res://Scenes/Menu/Menu.tscn"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Global.changeLevel("", false, true)
		yield(Global, "loadFinished")
		get_tree().quit()

func start(world):
	#$Polygon2D/AnimationPlayer.play_backwards("Enter")
	Global.changeLevel(world)
func _on_Button_pressed():
	start("res://Scenes/Main.tscn")
