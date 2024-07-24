extends CharacterBody2D

@onready var player: CharacterBody2D

var speed = 4.0

var aggro = false
var aggro_chance = 0.0
var aggro_reset = 0.0
var aggro_threshold = 2.0
var aggro_range = 100

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	aggro_chance += randf_range(.01, 0.02)

	if aggro_chance >= aggro_threshold:

		## play haunting sound
		if position.distance_to(player.position) <= aggro_range:

			aggro = true
			attack_player()
		
func attack_player():
	aggro = false
	aggro_chance = aggro_reset
	var move_dir = position - player.position
	velocity = -speed * move_dir

	move_and_slide()

func estalecido():
	pass
	## animation estalecido
	## play sound
	## speed = 0
	## start estalecido timer
