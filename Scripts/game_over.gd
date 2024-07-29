extends Control

@onready var game = get_tree().get_root().get_node("Game")

@onready var audio_manager: Node2D
# TODO play sound ghost game over
# Called when the node enters the scene tree for the first time.
func _ready():
	audio_manager = get_tree().get_first_node_in_group("audiomanager")
	audio_manager.play_gameover()
	audio_manager.music.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_retry_button_pressed():
	audio_manager.stop_gameover()
	game.retry_level()


func _on_quit_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

