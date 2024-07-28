extends CharacterBody2D

class_name Enemy

@onready var player: CharacterBody2D

enum States 
{
WANDER, 
CHASE, 
FOLLOW,
STUNNED, 
BANISHED,

}
var state = States.WANDER

# Parameters
var wander_speed = 600
var chase_speed = 70
var stunned_duration = 4.0
var aggro_range = 100
var follow_range = 500

# Personality multipliers
var speed_multiplier = 1.0
var chase_time_multiplier = 1.0
var stun_time_multiplier = 1.0

# Timers
var stunned_timer = 0.0
var chase_timer = 0.0

@export var stunned: Timer
@onready var collision_shape_2d = $CollisionShape2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ghost_stun = $Ghost_stun


@export var chase: Timer
@export var wander_timer: Timer

var wander_time = 3.0
@onready var wander_direction = Vector2(randf() - 0.5, randf() - 0.5).normalized()

var can_damage = true
@onready var damage_timer = $DamageTimer


## sfx

## use group to find audio manager
var audio_manager: Node2D


func _ready():
	
	audio_manager = get_tree().get_first_node_in_group("audiomanager")
	
	wander_time = randf_range(1.0, 3.0)  # Set an initial timer value
	
	# Assign random multipliers for personality
	speed_multiplier = randf_range(0.5, 2)
	chase_time_multiplier = randf_range(0.5, 1.2)
	stun_time_multiplier = randf_range(0.8, 1.2)
	
	# Find the player
	player = get_tree().get_first_node_in_group("player")


func _process(delta):
	match state:
		States.WANDER:
			ghost_stun.hide()
			audio_manager.play_sleep()
			animated_sprite_2d.self_modulate.a = 1
			collision_shape_2d.disabled = false
			_wander(delta)
		States.CHASE:
			ghost_stun.hide()
			audio_manager.play_haunt()
			animated_sprite_2d.self_modulate.a = 1
			collision_shape_2d.disabled = false
			_chase(delta)
		States.STUNNED:
			audio_manager.play_stun()
			_stunned(delta)
			collision_shape_2d.disabled = true
			animated_sprite_2d.self_modulate.a = 0.0
			ghost_stun.show()
		States.FOLLOW:
			ghost_stun.hide()
			animated_sprite_2d.self_modulate.a = 1
			collision_shape_2d.disabled = false
			_follow(delta)
		States.BANISHED:
			ghost_stun.hide()
			audio_manager.play_banished()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is Player and can_damage and player.catnip_power == false:
			can_damage = false
			damage_timer.start()
			player.take_damage()
		elif collider is Player and player.catnip_power == true:
			queue_free() ##TODO create dying sequece

func _physics_process(delta):
	match state:
		States.WANDER, States.CHASE:
			move_and_slide()

func _wander(delta):
	
	velocity = wander_direction * wander_speed * delta
	
	if player.global_position.distance_to(global_position) < aggro_range:
		state = States.CHASE
		chase_timer = 3.0 * chase_time_multiplier

func choose_wander_direction():
	wander_direction = Vector2(randf() - 0.5, randf() - 0.5).normalized()

func _chase(delta):
	# Move towards the player
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * chase_speed * speed_multiplier
	
	chase_timer -= delta
	if chase_timer <= 0:
		state = States.WANDER

func _follow(delta):
	
	# Move towards the player, but keep some distance
	
	if player.global_position.distance_to(global_position) > follow_range:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * chase_speed * speed_multiplier
	else:
		state = States.WANDER

func _stunned(delta):
	stunned_timer -= delta
	if stunned_timer <= 0:
		animated_sprite_2d.self_modulate.a = 1
		state = States.WANDER

## TODO Signal connectios
func _on_player_catnip_touch():
	state = States.BANISHED
	queue_free()

func _on_spell_hit():
	if player.catnip_power == true:
		queue_free()
	state = States.STUNNED
	stunned_timer = stunned_duration * stun_time_multiplier

func _on_wander_timeout():

	choose_wander_direction()
	wander_timer.start(randf_range(3.0, 5.0))


func _on_can_damage_timer_timeout():
	can_damage = true
