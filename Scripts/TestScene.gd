extends Spatial

var captured = true

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #Captures the cursor, makes it invisible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("dev_exit"): #If we press a button
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) #Make the cusor visable, releases it
		get_tree().change_scene("res://Scenes/main_menu.tscn") #exit to main menu
	if Input.is_action_just_pressed("dev_restart"):
		get_tree().reload_current_scene() #Restarts the current scene
	if Input.is_action_just_pressed("ui_accept"):
		if captured == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #Captures the cursor, makes it invisible
			captured = true
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) #Make the cusor visable, releases it
			captured = false