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
const MAX_SPEED = 5
const MAX_RUNNING_SPEED = 9
const MAX_CROUCH_SPEED = 2
const ACCEL = 5
const DEACCEL = 10
const WALK_SOUND_SPEED = 20
var walk_frame = 0

#jumping
var jump_height = 8
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
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT): #if clicking the mouse
		$Head/Camera/Hand1/Sprite.visible = false #extend hand
		$Head/Camera/Hand1/SpriteExtend.visible = true
		#shoot projectile -------------------------------------------------------------this isnt working--------------------------------------
		#var projectile1 = load("res://Scenes/Projectile1.tscn")
		#var projectile1_instance = projectile1.instance()
		#projectile1_instance.set_name("projectile1")
		#projectile1_instance.position(Vector3(1,0,0))
		#add_child(projectile1_instance)
		
	else: #otherwise
		$Head/Camera/Hand1/Sprite.visible = true #dont extend hand
		$Head/Camera/Hand1/SpriteExtend.visible = false

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
		global.player_on_ground = true
		has_contact = true
	else:
		if !$FeetCast.is_colliding():
			global.player_on_ground = false
			has_contact = false
	if (has_contact and !is_on_floor()):
		move_and_collide(Vector3(0,-1,0))
	
	#apply gravity
	velocity.y += gravity * delta
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	#figure out what speed to be moving & if crouching
	var speed
	if Input.is_action_pressed("move_sprint"): #if sprint key, sprint speed. this takes precedence
		speed = MAX_RUNNING_SPEED
		jump_height = 8
		var capsule = $CollisionShape.get("shape")
		capsule.set("height", 1.5)
		if $Head.translation.y < 1: #make sure no longer crouched
				$Head.translate(Vector3(0,.1,0))
	else:
		if Input.is_action_pressed("crouch"): #if crouch key, and not sprint key, crouch speed
			speed = MAX_CROUCH_SPEED
			jump_height = 4
			var capsule = $CollisionShape.get("shape")
			capsule.set("height", .75)
			if $Head.translation.y > 0: #make sure crouched
				$Head.translate(Vector3(0,-.1,0))
		else:
			speed = MAX_SPEED #if neither modifier key is pressed, use base speed
			jump_height = 8
			var capsule = $CollisionShape.get("shape")
			capsule.set("height", 1.5)
			if $Head.translation.y < 1: #make sure not crouched
				$Head.translate(Vector3(0,.1,0))
	
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
	global.current_total_velocity = abs(velocity.x) + abs(velocity.z)  #update the global speed so we can reference it elseware
	
	#play sound
	if velocity.x > .5 or velocity.x < -.5 or velocity.z > .5 or velocity.z < -.5: #if moving
		if global.player_on_ground == true: #and on ground
			walk_frame += 1
			if walk_frame > 2500 * delta - (2 * global.current_total_velocity):
				walk_frame = 0
				$WalkSFX3D.play()

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
			$Head/Camera.rotate_x(deg2rad(-change))
			camera_angle += change
		camera_change = Vector2()