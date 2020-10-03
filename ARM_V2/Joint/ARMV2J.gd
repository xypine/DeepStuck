extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(float) var speed_base = .01
export(float) var maxRange = 400
onready var modules = []
onready var target

export(bool) var reverseIK = false
export(bool) var gravity = true
export(float) var gravityBase = 0
export(bool) var enabled = true
export(Vector2) var up = Vector2(0,-1) 

export(int) var joints = 5
export(NodePath) var target_ext
var target_ext_instance
# Called when the node enters the scene tree for the first time.

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
func _ready():
	$Area2D/Line2D.hide()
	Global.addArm(self)
	gen()
	if reverseIK:
		modules.invert()
	pass # Replace with function body.

export(float) var length = 100
export(float) var thickness = 10
export(float) var thicknessChange = 1.0
func gen():
#	for c in get_children():
#		remove_child(c)
	var last_node = self
	for i in range(joints):
		var line = Line2D.new()
		line.points = [Vector2(0, -length), Vector2(0, length)]
#		line.self_modulate = Color(255, 255, 255, 0.5)
		if i > 0:
			line.position.y = length
		line.width = thickness
		for _w in range(i):
			line.width = line.width / thicknessChange
		last_node.add_child(line)
		modules.append(line)
		last_node = line
	target = modules[modules.size()-1]
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
var threshold = 1
export(bool) var enableRotation = false
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
		var ind2 = 0
		var vp = thickness
		for p in i.points:
#			for w in range(ind2):
#				vp = vp / thicknessChange
			poly.append(to_local(i.to_global(p)) - Vector2(vp/2, 0))
			ind2 += 1
	var pol2 = poly + PoolVector2Array()
	pol2.invert()
	
	var ind2 = 0
	for p in pol2:
		var vp = thickness
#		for w in range(pol2.size() - ind2):
#			vp = vp / thicknessChange
		poly.append(to_local(to_global(p + Vector2(vp, 0))))
		ind2 += 1
	if enabled:
		$Area2D/CollisionPolygon2D.polygon = poly + PoolVector2Array()
		$Area2D/Polygon2D.polygon = poly + PoolVector2Array()
		$Area2D/LightOccluder2D.occluder.polygon = poly + PoolVector2Array()
	else:
		$Area2D/CollisionPolygon2D.polygon = PoolVector2Array()
		$Area2D/Polygon2D.polygon = PoolVector2Array()
		$Area2D/LightOccluder2D.occluder.polygon = PoolVector2Array()
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

func _on_Area2D_body_shape_exited(body_id, _body, _body_shape, _area_shape):
	pass
	if ( body_id in colliding):
		colliding.remove(colliding.find(body_id))
	is_colliding = colliding.size() > 0
