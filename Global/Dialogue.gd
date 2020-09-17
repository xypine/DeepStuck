extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal dialogueFinished

enum speaker{ME, LightGuy}

var dialogs = {
	"start" : [
			["...", speaker.ME],
			["Where am I?", speaker.ME],
		]
}
var playing = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func speak(id):
	playing = false
	$DialogueFrame/Base.visible = true
	for i in dialogs[id]:
		playing = false
		$DialogueFrame/Base/Label.text = i[0]
		$DialogueFrame/AnimationPlayer.play("TextIn")
		yield($DialogueFrame/AnimationPlayer, "animation_finished")
		playing = true
		yield(self, "dialogueFinished")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if playing:
			hideSpeak()
			emit_signal("dialogueFinished")
func hideSpeak(instant=false):
	$DialogueFrame/AnimationPlayer.play("TextOut")
	if not instant:
		yield($DialogueFrame/AnimationPlayer, "animation_finished")
	$DialogueFrame/Base.visible = false
