extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	done = "start" in Global.cutsDone
	if not done:
		Global.player.control = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


var done = false
func _on_Start_body_entered(body):
	if body == Global.player and not done:
		Global.freeze = false
		print("Player has entered the starting point")
		DialogueSystem.speak("start")
		yield(DialogueSystem, "dialogueFinishedALL")
		Global.player.control = true
		done = true
		Global.cutsDone.append("start")
		Global.freeze = false


func _on_Water2D_water_entered(_water, _impact_pos, _body_id, body, _body_shape, _area_shape):
	if body == Global.player:
		Global.doLoad()
#		Global.changeLevel("", true, false, self)
