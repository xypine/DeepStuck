extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const GRAVITY = 20
const ACCELERATION = 50 * 2.2
const MAX_SPEED = 200
const JUMP_HEIGHT = -550
var UP = Vector2(0, -1)

var motion = Vector2()
var walljumps = 0
var resetJumps = false
var doublejumps = 0

func toDict():
	var save_dict = {
		"UP" : UP,
		"motion" : motion,
		"walljumps" : walljumps,
		"resetJumps" : resetJumps,
		"doublejumps" : doublejumps
		,
		"transform" : transform
		,
		"freeze" : Global.freeze
	}
	return save_dict
func fromDict(dict):
	var s = $Camera2D.smoothing_enabled
	$Camera2D.smoothing_enabled = false
	for i in dict:
		if i == "freeze":
			Global.freeze = dict[i]
		else:
			set(i, dict[i])
	$Camera2D.smoothing_enabled = s
func _process(_delta):
	if Global.loading:
		$Camera2D.smoothing_speed += 1
		$Camera2D.zoom -= Vector2(0.02,0.02)
	else:
		var z = $Camera2D.zoom.x
		z = min(z+0.02, 1)
		$Camera2D.zoom = Vector2(z,z)

func _physics_process(delta):
	motion.y += GRAVITY
	motion.x = motion.x / 1.2
	if resetJumps:
		resetJumps = false
		walljumps = 1
		doublejumps = 1
	var xinput = 0
	if Input.is_action_just_pressed("ui_accept"):
		Global.freeze = not Global.freeze
	if Input.is_action_pressed("ui_right"):
		motion.x += ACCELERATION
		xinput += 1
	elif Input.is_action_pressed("ui_left"):
		motion.x -= ACCELERATION
		xinput -= 1
	if Input.is_action_just_pressed("ui_down"):
		motion.y -= JUMP_HEIGHT * 1.5
	
	if is_on_floor():
		resetJumps = true
		if Input.is_action_just_pressed("ui_up"):
			motion.y += JUMP_HEIGHT
	else:
		if is_on_wall() and Input.is_action_pressed("ui_up") and xinput > 0:
			if walljumps > 0:
				motion.y += JUMP_HEIGHT*2
#				motion.x += xinput * -40
				walljumps -= 1
		else:
			if Input.is_action_just_pressed("ui_up") and doublejumps > 0:
				motion.y += JUMP_HEIGHT
				doublejumps -= 1
#	print("---")
#	print(walljumps)
#	print(doublejumps)
	
	motion = move_and_slide(motion, UP)
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.player = self
	$Camera2D.zoom = Vector2(0.4,0.4)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
