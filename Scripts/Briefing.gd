extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var game: Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	game = get_tree().get_first_node_in_group("game")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_avancar_pressed():
	game.change_state(game.States.LOADING)
	


func _on_flip_back_pressed():
	animation_player.play_backwards("BookPageFlip")


func _on_flip_forward_pressed():
	animation_player.play("BookPageFlip")
