extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueSystem.hideSpeak(true)
	$Button2.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.currentLevel = "res://Scenes/Menu/Menu.tscn"
	if str(Global.autosave) != "a":
		$Button.text = "Continue"
		$Button2.show()
	if not Global.notfirst:
		Global.notfirst = true
		$Camera2D/AnimationPlayer.play("In")
	else:
		$Camera2D/AnimationPlayer.play("other")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Global.changeLevel("", false, true)
		yield(Global, "loadFinished")
		get_tree().quit()
	if Input.is_action_just_pressed("ui_accept"):
		_on_Button_pressed()

func start(world):
	#$Polygon2D/AnimationPlayer.play_backwards("Enter")
	Audio.StartPlayer.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.changeLevel(world)
func _on_Button_pressed():
	Global.loadFromFile()
	if str(Global.autosave) != "a":
		Global.loadRequested = true
	start("res://Scenes/Main.tscn")


func _on_Button2_pressed():
	Global.zeroProgress()
	Global.saveToFile()
	start("res://Scenes/Main.tscn")
