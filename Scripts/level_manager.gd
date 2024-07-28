extends Node2D

var player: CharacterBody2D
var game: Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	game = get_tree().get_first_node_in_group("game")
	player.reset_player()
	game.reset_finds()
	game.level_interface.show()

func _process(delta):
	pass
