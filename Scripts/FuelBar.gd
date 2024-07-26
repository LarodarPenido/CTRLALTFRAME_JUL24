extends Control

@onready var progress_bar = $ProgressBar
@onready var game: Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_tree().get_first_node_in_group("game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	progress_bar.value = game.fuel_level
