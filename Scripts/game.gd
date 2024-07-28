extends Node2D

@onready var post_process = $CanvasLayer/PostProcess
@onready var quake_timer = $QuakeTimer

@onready var player: CharacterBody2D

enum States 
{
MAINMENU,
BRIEFING,
BOOK,
LOADING,
LEVEL01,
LEVEL02,
LEVEL03,
GAMEOVER,
END,
}

var current_state = States.MAINMENU
var current_level = ""

## Progression
var wand_level = 1

#var playing_level_01 = false
#var playing_level_02 = false
#var playing_level_03 = false
#
#var level_01_complete = false
#var level_02_complete = false
#var level_03_complete = false

## Win Conditions
var player_embarked = false
var fuel_level = 0
var star_found = false
var book_found = false
var fuel_full = false

var level_complete = false # fuel cheio e star e book pegos = level complete() - level complete false

## Cutscenes


## Levels
const LEVEL_01 = preload("res://Scenes/Level01.tscn")
const LEVEL_02 = preload("res://Scenes/Level02.tscn")
const LEVEL_03 = preload("res://Scenes/Level03.tscn")

## UI toggles
@onready var story = $CanvasLayer/Story
@onready var main_menu = $CanvasLayer/MainMenu
@onready var level_interface = $CanvasLayer/LevelInterface

@onready var audio_manager: Node2D


func get_current_state() -> int:
	return current_state

func _ready():
	player = get_tree().get_first_node_in_group("player")
	#audio_manager = get_tree().get_first_node_in_group("audiomanager")
	#audio_manager.play_music()
	story.hide()
	level_interface.hide()
	enter_state(current_state)


	
func enter_state(state):
	match state:
		States.MAINMENU:
			print(current_state)
			enter_main_menu()
		States.BRIEFING:
			print(current_state)
			enter_briefing()
		States.BOOK:
			print(current_state)
			enter_book()
		States.LOADING:
			print(current_state)
			enter_loading()
		States.LEVEL01:
			print(current_state)
			enter_level_01()
		States.LEVEL02:
			print(current_state)
			enter_level_02()
		States.LEVEL03:
			print(current_state)
			enter_level_03()
		States.GAMEOVER:
			print(current_state)
			enter_gameover()
		States.END:
			print(current_state)
			enter_end()

			
func exit_state(state):
	match state:
		States.BRIEFING:
			exit_briefing()
		States.BOOK:
			exit_book()
		States.LOADING:
			exit_loading()
		States.LEVEL01:
			exit_level_01()
		States.LEVEL02:
			exit_level_02()
		States.LEVEL03:
			exit_level_03()
		States.GAMEOVER:
			exit_gameover()
		States.END:
			exit_end()

			
func change_state(new_state):
	exit_state(current_state)
	current_state = new_state
	enter_state(current_state)
	
			



func enter_main_menu():
	main_menu.show()
	story.hide()
	level_interface.hide()


func enter_briefing():
	main_menu.hide()
	story.show()
	level_interface.hide()
	
	get_tree().change_scene_to_file("res://Scenes/briefing.tscn")

func exit_briefing():
	story.hide()
	

func enter_book():
	main_menu.hide()
	story.show()
	
	
func exit_book():
	main_menu.hide()
	story.show()


func enter_loading():
	main_menu.hide()
	story.show()
	get_tree().change_scene_to_file("res://Scenes/loading_screen.tscn")

func exit_loading():
	main_menu.hide()
	story.show()
	
func enter_level_01():
	main_menu.hide()
	level_interface.show()
	get_tree().change_scene_to_file("res://Scenes/Level01.tscn")
	# Additional setup for level 01 state

func exit_level_01():
	level_interface.hide()
	reset_finds()
	# Additional cleanup for level 01 state

func enter_level_02():
	main_menu.hide()
	get_tree().change_scene_to_file("res://Scenes/Level02.tscn")


func exit_level_02():
	main_menu.hide()


func enter_level_03():
	get_tree().change_scene_to_file("res://Scenes/Level03.tscn")

func exit_level_03():
	# Cleanup for level 03
	pass

func enter_gameover():
	# Setup for game over state
	pass

func exit_gameover():
	# Cleanup for game over state
	pass

func enter_end():
	# Setup for end state
	pass

func exit_end():
	# Cleanup for end state
	pass



func _on_start_game_pressed():
	change_state(States.BRIEFING)

func _on_level_01_completed():
	## TODO pass thourhg book scene
	change_state(States.LEVEL02)

func _on_level_02_completed():
	## TODO pass thourhg book scene
	change_state(States.LEVEL03)

func _on_level_03_completed():
	## TODO pass thourhg book scene
	change_state(States.END)

func _on_gameover():
	change_state(States.GAMEOVER)

func _on_quit_pressed():
	get_tree().quit()


func _process(delta):
	pass
	## TODO if input esc - go to menu

## VFX
func screen_shake(intensity: float, duration: float) -> void:
	post_process.configuration.ScreenShake = true
	post_process.configuration.ScreenShakePower = intensity
	quake_timer.start(duration)
		
func shake_reset():
	post_process.configuration.ScreenShake = false
	post_process.configuration.ScreenShakePower = 0.0

func _on_quake_timer_timeout():
	shake_reset()

## Item controls

func _on_item_picked(item_type: String):

	match item_type:
		"ship_fuel":
			_update_fuel_bar()
		"red_mineral":
			_collect_red_mineral()
		"star":
			_collect_star_fragment()
		"book":
			_collect_book()
			
func _update_fuel_bar():
	fuel_level += 1
	prints("fuel collected", fuel_level)
	if fuel_level == 10:
		fuel_full = true
		prints("tanque cheio")

func _collect_red_mineral():
	wand_level += 1
	print("red min collected")
	
func _collect_star_fragment():
	star_found = true

func _collect_book():
	book_found = true
	
func reset_finds():
	#player.hitpoints = player.max_hitpoints
	star_found = false
	book_found = false
	fuel_level = 0

func retry_level():
	if current_level != "":
		get_tree().change_scene_to_file(current_level)
	else:
		print("No level to retry")

