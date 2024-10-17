extends Control


var default = load("res://Cursors/pointer_b_shaded.png")
var hand_open = load("res://Cursors/hand_thin_small_open.png")
var hand_closed = load("res://Cursors/hand_thin_small_closed.png")
var disabled = load("res://Cursors/disabled.png")
var hotspot = Vector2(15, 15)


var mouse_speed = 200
var cursor_position = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Input.set_custom_mouse_cursor(default, 0, hotspot)
	
	# Initialize cursor position at the center of the screen or desired position
	cursor_position = Vector2(get_viewport().size / 2)
	position = cursor_position


#func _process(delta):
	#handle_controller_input(delta)
	#position = cursor_position  # Update the visual cursor position
#
#
#func handle_controller_input(delta):
	## Get input from the left stick (for a controller)
	#var move_direction = Vector2(
		#Input.get_axis("left_stick_x", "left_stick_x"),
		#Input.get_axis("left_stick_y", "left_stick_y")
		#)
	#
	## For D-pad movement
	#if Input.is_action_pressed("Left"):
		#move_direction.x = -1
	#if Input.is_action_pressed("Right"):
		#move_direction.x = 1
	#if Input.is_action_pressed("Up"):
		#move_direction.y = -1
	#if Input.is_action_pressed("Down"):
		#move_direction.y = 1
	#
	#
	## Move the cursor with left stick movement or D-pad buttons
	#cursor_position += move_direction * mouse_speed * delta
#
	## Clamp the cursor within screen bounds
	#cursor_position.x = clamp(cursor_position.x, 0, get_viewport().size.x)
	#cursor_position.y = clamp(cursor_position.y, 0, get_viewport().size.y)
