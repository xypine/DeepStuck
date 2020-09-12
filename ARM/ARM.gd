extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var speed_base = .01
export(float) var maxRange = 400
onready var modules = [
	$ARM_ARM,
	$ARM_ARM/ARM_ARM2,
	$ARM_ARM/ARM_ARM2/ARM_ARM3,
	$ARM_ARM/ARM_ARM2/ARM_ARM3/ARM_ARM4,
	$ARM_ARM/ARM_ARM2/ARM_ARM3/ARM_ARM4/ARM_ARM5,
	$ARM_ARM/ARM_ARM2/ARM_ARM3/ARM_ARM4/ARM_ARM5/ARM_ARM6,
	$ARM_ARM/ARM_ARM2/ARM_ARM3/ARM_ARM4/ARM_ARM5/ARM_ARM6/ARM_ARM7,
	$ARM_ARM/ARM_ARM2/ARM_ARM3/ARM_ARM4/ARM_ARM5/ARM_ARM6/ARM_ARM7/ARM_ARM8,
	$ARM_ARM/ARM_ARM2/ARM_ARM3/ARM_ARM4/ARM_ARM5/ARM_ARM6/ARM_ARM7/ARM_ARM8/ARM_ARM9,
	$ARM_ARM/ARM_ARM2/ARM_ARM3/ARM_ARM4/ARM_ARM5/ARM_ARM6/ARM_ARM7/ARM_ARM8/ARM_ARM9/ARM_ARM10/ARM_ARM11,
	$ARM_ARM/ARM_ARM2/ARM_ARM3/ARM_ARM4/ARM_ARM5/ARM_ARM6/ARM_ARM7/ARM_ARM8/ARM_ARM9/ARM_ARM10/ARM_ARM11/ARM_ARM12,
	$ARM_ARM/ARM_ARM2/ARM_ARM3/ARM_ARM4/ARM_ARM5/ARM_ARM6/ARM_ARM7/ARM_ARM8/ARM_ARM9/ARM_ARM10/ARM_ARM11/ARM_ARM12/ARM_ARMF,
]
onready var target = modules[modules.size()-1]

export(bool) var reverseIK = false
export(bool) var gravity = true
export(float) var gravityBase = 0
export(bool) var enabled = true
export(Vector2) var up = Vector2(0,-1) 

export(NodePath) var target_ext
var target_ext_instance

var loading = false
func toDict():
	var ct = []
	for i in modules:
		ct.append(var2str(i.transform))
	var dict = {
		"speed_base" : speed_base,
#		"modules" : modules,
#		"target" : target
#		,
		"reverseIK" : reverseIK,
		"gravity" : gravity,
		"gravityBase" : gravityBase,
		"enabled" : enabled,
		"up" : up
		,
#		"target_ext" : target_ext,
#		"target_ext_instance" : target_ext_instance
#		,
		"transform" : transform,
		"childrentrans" : ct
	}
	return dict
func fromDict(dict):
	loading = true
	for i in dict:
		if i == "childrentrans":
			var ind = 0
			for x in modules:
				x.transform = str2var(dict[i][ind])
				ind += 1
		else:
			set(i, dict[i])
	genColl()
	loading = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.addArm(self)
	if reverseIK:
		modules.invert()
	pass # Replace with function body.

func score(var mod):
	var rpoint = target.points[1]
	var point = target.to_global(rpoint)
	
	var dest = get_global_mouse_position()
	if is_instance_valid(target_ext_instance):
		dest = target_ext_instance.global_position
	var dist = dest - point
	var dist2 = 0
	for i in modules:
		if i != mod:
			dist2 = dist2 + ( point - i.global_position ).length()
	var final = dist.length()# - (dist2 / 20)
	if gravity:
		final = final + gravityBase - (point.y/20)
	return final - (colliding.size()*1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.freeze or loading:
		return
	target_ext_instance = get_node(target_ext)
	var org = score(target)
	if org > maxRange:
		org = org / 2
	var rot = 0
	for i in modules:
		org = score(i)
		if org > maxRange:
			org = org * .9
		var speed = max(speed_base * ( (score(i)+1)/10), speed_base)
		rot = 0
		i.rotate(speed)
		rot = rot + speed
		if(score(i) > org):
			i.rotate(-speed*2)
			rot = rot + -speed*2
		if(score(i) > org):
			i.rotate(-rot)
	genColl()
func genColl():
	var poly = PoolVector2Array()
	for i in modules:
		for p in i.points:
			poly.append(to_local(i.to_global(p)))
	var pol2 = poly + PoolVector2Array()
	pol2.invert()
	for p in pol2:
		poly.append(to_local(to_global(p + Vector2(10, 0))))
	if enabled:
		$Area2D/CollisionPolygon2D.polygon = poly + PoolVector2Array()
		$Area2D/Polygon2D.polygon = poly + PoolVector2Array()
	else:
		$Area2D/CollisionPolygon2D.polygon = PoolVector2Array()
		$Area2D/Polygon2D.polygon = PoolVector2Array()
#	print(score())
var colliding = []
var is_colliding = false
func _on_Area2D_body_shape_entered(body_id, _body, _body_shape, _area_shape):
	pass
	if not ( body_id in colliding):
		colliding.append(body_id)
	is_colliding = colliding.size() > 0

func _on_Area2D_body_entered(body):
	pass
	if not ( body in colliding):
		colliding.append(body)
	is_colliding = colliding.size() > 0


func _on_Area2D_body_exited(body):
	pass
	if ( body in colliding):
		colliding.remove(colliding.find(body))
	is_colliding = colliding.size() > 0

func _on_Area2D_body_shape_exited(body_id, body, body_shape, area_shape):
	pass
	if ( body_id in colliding):
		colliding.remove(colliding.find(body_id))
	is_colliding = colliding.size() > 0
