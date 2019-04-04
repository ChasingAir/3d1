extends Node2D

var display_size = OS.window_size #get screen size
var display_center = Vector2(display_size.x/2,display_size.y/2) #get screen center

# Called when the node enters the scene tree for the first time.
func _ready():
	translate(Vector2(display_center.x,display_center.y)) #move main_menu background to center

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("dev_exit"): #If we press a button
		get_tree().quit() #Exit the game
	
	if $PlayButton.pressed:
		play()
	if $OptionButton.pressed:
		options()
	if $QuitButton.pressed:
		quit()

func play():
	get_tree().change_scene("res://Scenes/TestScene.tscn")

func options():
	pass

func quit():
	get_tree().quit()