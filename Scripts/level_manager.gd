extends Node2D

## player hp
## fuel collection
## player embarked
## fuel enough
## collectibles left display

var player: CharacterBody2D

var game: Node2D


#const LEVEL_02 = preload("res://Scenes/Level02.tscn")

#var level_01 = true
#var level_02 = false
#var level_03 = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	game = get_tree().get_first_node_in_group("game")



func _process(delta):

	if player.player_embarked and game.fuel_full:
		advance_level()
		

func advance_level():
	game.change_state(game.States.BOOK)
