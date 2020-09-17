extends Light2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(int) var chatId = 0

onready var ChitChat = $ChitChat

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

var triggered = false

func _on_Area2D_body_entered(body):
	if not triggered:
		triggered = true
		DialogueSystem.speak(chatId)
