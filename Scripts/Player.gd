extends KinematicBody

var camera_angle = 0
var mouse_sensitivity = 5
var camera_change = Vector2()

var velocity = Vector3()
var direction = Vector3()

#fly variables
const FLY_SPEED = 40
const FLY_ACCEL = 4

#walk variables
var gravity = -9.8 * 3
const MAX_SPEED = 10
const MAX_RUNNING_SPEED = 18
const MAX_CROUCH_SPEED = 3
const ACCEL = 2
const DEACCEL = 20
var walk_frame = 0

#jumping
var jump_height = 10
var in_air = 0
var has_contact = false

func _ready():
	pass

func _physics_process(delta):
	aim()
	walk(delta)

func _input(event):
	if event is InputEventMouseMotion: #If there is mouse input
		camera_change = event.relative

func walk(delta):
	#reset the direction of the player
	direction = Vector3()
	
	#get the rotation of the camera
	var aim = $Head/Camera.get_global_transform().basis
	#check input and change direction
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	#normalize the direction
	direction = direction.normalized()
	
	if (is_on_floor()):
		has_contact = true
	else:
		if !$TailCast.is_colliding():
			has_contact = false
	if (has_contact and !is_on_floor()):
		move_and_collide(Vector3(0,-1,0))
	
	#apply gravity
	velocity.y += gravity * delta
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	#figure out what speed to be moving
	var speed
	if Input.is_action_pressed("move_sprint"): #if sprint key, sprint speed. this takes precedence
		speed = MAX_RUNNING_SPEED
	else:
		if Input.is_action_pressed("crouch"): #if crouch key, and not sprint key, crouch speed
			speed = MAX_CROUCH_SPEED
		else:
			speed = MAX_SPEED #if neither modifier key is pressed, use base speed
	
	#where would the player go at max speed
	var target = direction * speed
	
	var acceleration #this variable will hold current acceleration, using 
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	else:
		acceleration = DEACCEL
	
	#calculate a portion of the distance to go
	temp_velocity = velocity.linear_interpolate(target, acceleration * delta)
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	#jumping
	if has_contact and Input.is_action_just_pressed("jump"):
		velocity.y = jump_height
		has_contact = false
	
	#move
	velocity = move_and_slide(velocity, Vector3(0,1,0), 0.15)
	
	#play sound
	if velocity.x > 1 or velocity.x < -1 or velocity.z > 1 or velocity.z < -1:
		walk_frame += 1
		var walk_sfx_speed = (velocity.x + velocity.z) / 10
		if walk_frame > walk_sfx_speed:
			walk_frame = 0
			$WalkSFX.play()

func fly(delta):
	#reset the direction of the player
	direction = Vector3()
	
	#get the rotation of the camera
	var aim = $Head/Camera.get_global_transform().basis
	#check input and change direction
	if Input.is_action_pressed("move_forward"):
		direction -= aim.z
	if Input.is_action_pressed("move_backward"):
		direction += aim.z
	if Input.is_action_pressed("move_left"):
		direction -= aim.x
	if Input.is_action_pressed("move_right"):
		direction += aim.x
	#normalize the direction
	direction = direction.normalized()
	
	#where would the player go at max speed
	var target = direction * FLY_SPEED
	
	#calculate a portion of the distance to go
	velocity = velocity.linear_interpolate(target, FLY_ACCEL * delta)
	
	#move
	move_and_slide(velocity)

func aim():
	if camera_change.length() > 0:
		$Head.rotate_y(deg2rad(-camera_change.x * .05 * mouse_sensitivity)) #Rotate head
		
		var change = camera_change.y * .05 * mouse_sensitivity
		if change + camera_angle < 90 and change + camera_angle > -90:
			$Head/Camera.rotate_z(deg2rad(change))
			camera_angle += change
		camera_change = Vector2()