extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var dialogs = {
	"start" : "Hi there!"
}
var playing = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func speak(id):
	$DialogueFrame/Base/Label.text = dialogs[id]
	$DialogueFrame/AnimationPlayer.play("TextIn")
	playing = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if playing:
			$DialogueFrame/AnimationPlayer.play("TextOut")
func hideSpeak():
	$DialogueFrame/AnimationPlayer.play("TextOut")
	yield($DialogueFrame/AnimationPlayer, "animation_finished")
