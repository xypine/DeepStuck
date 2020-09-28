extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal dialogueFinished
signal dialogueFinishedALL

enum speaker{ME, LightGuy, game}

var dialogs = {
	"start" : [
			["uh...", speaker.ME],
			["Where am I?", speaker.ME],
		],
	0 : [
			["The roots will help you on your way.", speaker.LightGuy],
	],
	1 : [
			["Or at least will try to :)", speaker.LightGuy],
			["If you find yourself stuck, just press r to restart from the latest checkpoint!", speaker.LightGuy],
	],
	2 : [
			["If you ever think them being still would help...", speaker.LightGuy],
			["You know, they wouldn't mind taking a break ;)", speaker.LightGuy],
			["( Press SPACE to freeze and unfreeze roots )", speaker.game],
	],
}
var playing = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func speak(id, freezeOthers = true):
	playing = false
	$DialogueFrame/Base.visible = true
	var oldFreeze = Global.freeze
	var oldControl = Global.player.control
	var oldPau = Global.pause
	if freezeOthers:
		Global.freeze = true
		Global.player.control = false
		Global.pause = true
	for i in dialogs[id]:
		playing = false
		$DialogueFrame/Base/Label.text = i[0]
		$DialogueFrame/Base/Speaker.text = str(speaker.keys()[i[1]])
		$DialogueFrame/AnimationPlayer.play("TextIn")
		yield($DialogueFrame/AnimationPlayer, "animation_finished")
		playing = true
		yield(self, "dialogueFinished")
	hideSpeak(true)
	if freezeOthers:
		Global.freeze = oldFreeze
		Global.player.control = oldControl
		Global.pause = oldPau
	emit_signal("dialogueFinishedALL")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if playing:
			hideSpeak(false, true)
			yield($DialogueFrame/AnimationPlayer, "animation_finished")
			emit_signal("dialogueFinished")
func hideSpeak(instant=false, transition=false):
	$DialogueFrame/AnimationPlayer.play("TextOut")
	if not instant:
		yield($DialogueFrame/AnimationPlayer, "animation_finished")
	if not transition:
		$DialogueFrame/Base.visible = false
