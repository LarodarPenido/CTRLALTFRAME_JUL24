extends Control
@onready var star = $Star

@onready var game: Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_tree().get_first_node_in_group("game")

func _process(delta):
	if game.star_found:
		star.show()
	else:
		star.hide()
