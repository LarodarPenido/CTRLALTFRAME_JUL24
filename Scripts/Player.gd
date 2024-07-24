extends CharacterBody2D

class_name Player

@export var speed = 400
@export var acceleration = 1
var current_speed: Vector2 = Vector2.ZERO
# acceleration system
# inertia system


## audio

## vfx
@onready var animated_sprite_2d = $AnimatedSprite2D


@onready var input_direction: Vector2

func get_input():
	input_direction = Input.get_vector("left", "right", "up", "down")
	

func _physics_process(delta):
	
	var mouse_pos = get_global_mouse_position()
	
	get_input()
	
		# Apply acceleration
	var target_speed = input_direction * speed
	current_speed = current_speed.lerp(target_speed, acceleration * delta)  
	velocity = current_speed
	
	# Apply deceleration when no input
	if input_direction == Vector2.ZERO:
		current_speed = current_speed.lerp(Vector2.ZERO, acceleration * delta) 
		velocity = current_speed
	
	move_and_slide()
	
	if mouse_pos.x < global_position.x:
		animated_sprite_2d.flip_h = true 
	elif mouse_pos.x > global_position.x:
		animated_sprite_2d.flip_h = false
