extends Control

@onready var game = get_tree().get_root().get_node("Game")

# TODO play sound ghost game over
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_retry_button_pressed():
	game.retry_level()


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
