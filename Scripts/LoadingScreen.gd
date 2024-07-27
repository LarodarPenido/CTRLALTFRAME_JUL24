# LoadingScreen.gd
extends Control

var game: Node2D


var particles_to_preload = [
	"res://Scenes/break_particles.tscn",
	"res://Scenes/player.tscn",
	"res://Scenes/ship.tscn",
	"res://Scenes/spell.tscn",
]

var current_index = 0

@export var main_scene_path: String = "res://path_to_your_main_scene.tscn"

func _ready():
	preload_particles()
	game = get_tree().get_first_node_in_group("game")

func preload_particles() -> void:
	preload_next_particle()

func preload_next_particle() -> void:
	if current_index < particles_to_preload.size():
		var path = particles_to_preload[current_index]
		ResourceLoader.load_threaded_request(path)
		await get_tree().process_frame  # Allow the loading to progress
		_on_particle_loaded(path)
	else:
		print("loading worked")
		game.change_state(game.States.LEVEL01)

func _on_particle_loaded(path: String) -> void:
	if ResourceLoader.load_threaded_get_status(path) == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		ResourceLoader.load_threaded_get(path)  # Ensure the resource is fully loaded
		current_index += 1
		preload_next_particle()


