extends KinematicBody

signal tile_selected(vec)
signal tile_scan(vec)
signal stop_scan

var camera_angle = 0
var mouse_sens = 0.3
var velocity = Vector3()
var dir = Vector3()

var gravity = -9.8*3
const SPEED = 20

const ACCEL = 2
const DEACCEL = 6
const JUMP_HEIGHT = 12

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sens))
		var change = -event.relative.y * mouse_sens
		if change + camera_angle < 90 and change + camera_angle > -90:
			$Camera.rotate_x(deg2rad(change))
			camera_angle += change
	

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func left_button_pressed():
	var ray = $Camera/RayCast
	if ray.is_colliding():
		emit_signal("tile_selected", ray.get_collision_point() - ray.get_collision_normal())

func right_button_pressed():
	var ray = $Camera/RayCast
	if ray.is_colliding():
		emit_signal("tile_scan", ray.get_collision_point() - ray.get_collision_normal())		
	
func _physics_process(delta):
	dir = Vector3()
	var aim = $Camera.global_transform.basis
	if Input.is_action_pressed("move_forward"):
		dir -= aim.z
	if Input.is_action_pressed("move_backward"):
		dir += aim.z
	if Input.is_action_pressed("move_left"):
		dir -= aim.x
	if Input.is_action_pressed("move_right"):
		dir += aim.x
	
	dir = dir.normalized()
	
	velocity.y += gravity * delta
	
	var tv = velocity
	tv.y = 0
	
	var target = dir * SPEED
	
	var acc
	if dir.dot(tv) > 0:
		acc = ACCEL
	else:
		acc = DEACCEL
	
	tv = tv.linear_interpolate(target, acc * delta)
	
	velocity.x = tv.x
	velocity.z = tv.z
	
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_HEIGHT

var send_rmb_release_signal = false

func _process(delta):		
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		right_button_pressed()
		send_rmb_release_signal = true
	else:
		if Input.is_action_just_pressed("LMB"):
			left_button_pressed()
		if send_rmb_release_signal:
			emit_signal("stop_scan")


func _on_Void_body_entered(body):
	if body == self:
		call_deferred("fallen")
		
func fallen():
	Global.game_over("You fell out of the sky...")
