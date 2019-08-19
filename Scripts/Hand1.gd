extends Node2D

var display_size = OS.window_size #get current window resolution
var hand_offset = display_size.x/2 + display_size.x/10 #set hand offset amount via division to scale correctly
var bob_amount = 3000
var x = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	translate(Vector2(hand_offset,display_size.y)) #offset hand origin by screen resolution height and offset width

# This was an attempt at hand animation, but I'm thinking it should be done with tiles in the hand sprite instead?
#func _process(delta): #called every frame
#	if global.current_total_velocity > 1 and global.player_on_ground == true: #if moving & on ground
#		if x < (bob_amount * delta) - global.current_total_velocity:
#			hand_position = get("position")
#			hand_position.set = Vector2(.25,.5)
#			x += 1
#		else: #(greater than 100)
#			if x < ((bob_amount * delta) - global.current_total_velocity) * 2:
#				Position2D(Vector2(-.25,-.5))
#				x += 1
#			else:
#				x = 0