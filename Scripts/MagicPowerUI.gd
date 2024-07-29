extends Control

@onready var game: Node2D
@onready var label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_tree().get_first_node_in_group("game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text = "Poder: " + str(game.wand_level)
	
	
