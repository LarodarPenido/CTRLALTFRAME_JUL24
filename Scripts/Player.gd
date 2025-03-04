extends CharacterBody2D

class_name Player

@onready var is_alive = true

@onready var game: Node2D
@onready var hp_bar: Control

@export var wand: Node2D


var player_embarked = false

# Catnip mode
@export var catnip_power_duration = 7.0
var catnip_power = false
@onready var catnip_power_timer = $CatnipPower
@onready var catnip_aura = $Control/CatnipAura
@onready var aura = $Aura


@onready var wand_node = $Node2D

var invincible = false
@onready var invincible_timer = $InvincibleTimer
@onready var dying_timer = $DyingTimer



@export var max_hitpoints = 3
@export var hitpoints = 3

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ghost_sprite = $GhostSprite


@export var speed = 300
@export var acceleration = 1
var current_speed: Vector2 = Vector2.ZERO


## VFX
@export var post_process: Node
@onready var player_sprite = $AnimatedSprite2D
@onready var input_direction: Vector2

## SFX

@onready var audio_manager: Node2D

func _ready():
	is_alive = true
	game = get_tree().get_first_node_in_group("game")
	audio_manager = get_tree().get_first_node_in_group("audiomanager")
	hp_bar = get_tree().get_first_node_in_group("hpbar")
	audio_manager.play_music()
	
func connect_collectible(item):
	item.connect("item_picked", Callable(self, "_on_item_picked"))

func _on_item_picked(item_type: String):
	match item_type:
		"catnip":
			_activate_catnip_powerup()
	
func _activate_catnip_powerup():
	audio_manager.play_catnip_music()
	catnip_power = true
	speed = 450
	acceleration = 3
	
	catnip_aura.show()
	aura.show()
	catnip_aura.self_modulate.a = catnip_power_timer.time_left
	aura.self_modulate.a = catnip_power_timer.time_left
	catnip_power_timer.start(catnip_power_duration)
	
	# play catnip music
	
	# catnip beeps to indicate ending ## TODO ## BUG

	
	
func _process(delta):
	hp_bar.update_health(hitpoints)
	if catnip_power:
		catnip_aura.self_modulate.a = catnip_power_timer.time_left
		aura.self_modulate.a = catnip_power_timer.time_left
		

func get_input():
	input_direction = Input.get_vector("left", "right", "up", "down")
	
func _physics_process(delta):
	var current_state = game.get_current_state()
	if is_alive:  ##current_state in [game.States.LEVEL01, game.States.LEVEL02, game.States.LEVEL03] and # restrict to level?
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
			player_sprite.flip_h = true 
		elif mouse_pos.x > global_position.x:
			player_sprite.flip_h = false
			
			
		#blink()


func take_damage():
	if !is_alive:
		return
	invincible = true
	invincible_timer.start()
	audio_manager.play_player_hit()
	game.screen_shake(.1, .1)
	hitpoints -= 1
	#hp_bar.update_health(hitpoints)
	if hitpoints <= 0 :
		is_alive = false
		die()
	# TODO dying system
	#hurt sound
	#hurt anim
func die():
	dying_timer.start()
	animated_sprite_2d.hide()
	ghost_sprite.show()

func _on_catnip_power_timeout():
	deactivate_catnip_powerup()

func deactivate_catnip_powerup():
	audio_manager.play_music()
	catnip_aura.hide()
	aura.hide()
	catnip_power = false
	speed = 300
	acceleration = 1


func _on_invincible_timer_timeout():
	invincible = false
#
func blink():
	print("blinking")
	if invincible:
		if player_sprite.self_modulate.a > 0.9:
			player_sprite.self_modulate.a = lerp(1,0, 0.7)
		if player_sprite.self_modulate.a < 0.2:
			player_sprite.self_modulate.a = lerp(0,1, 0.7)
	else:
		player_sprite.self_modulate.a = 1



func _on_dying_timer_timeout():
	reset_player()
	game.change_state(game.States.GAMEOVER)
	
func reset_player():
	is_alive = true
	hitpoints = max_hitpoints
	invincible = false
