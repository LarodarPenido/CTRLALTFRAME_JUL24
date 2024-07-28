extends Control
@onready var book = $Book
@onready var game: Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_tree().get_first_node_in_group("game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game.book_found:
		book.show()
	else:
		book.hide()
