extends Node2D

# detect player
# toggle embarked state
#toggle Sprites visible
#liftoff
#land
@onready var player: CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	player.player_embarked = true
	#print("aboard")


func _on_area_2d_body_exited(body):
	player.player_embarked = false
	#print("outboard")
