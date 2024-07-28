extends Node2D

@onready var post_process = $CanvasLayer/PostProcess
@onready var quake_timer = $QuakeTimer

@onready var player: CharacterBody2D

const ENDING = preload("res://Scenes/ending.tscn")


enum States 
{
MAINMENU,
BRIEFING,
BOOK,
LOADING,
LEVEL01,
TELESCOPE01,
LEVEL02,
TELESCOPE02,
LEVEL03,
GAMEOVER,
END,
}

var current_state = States.MAINMENU
var current_level = ""

## Progression
var wand_level = 1

## Win Conditions
var fuel_level = 0
var star_found = false
var book_found = false
var fuel_full = false

var level_complete = false # fuel cheio e star e book pegos = level complete() - level complete false

## Debug
@onready var state_checker_timer = $StateCheckerTimer

## Cutscenes
## Level 01 Begin
@onready var arrival_01 = $CanvasLayer/Story/Arrival01




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
	state_checker_timer.start()
	story.hide()
	level_interface.hide()
	enter_state(current_state)
	
func enter_state(state):
	match state:
		States.MAINMENU:
			print(" enter state main menu")
			enter_main_menu()
		States.BRIEFING:
			print("enter state briefing")
			enter_briefing()
		States.BOOK:
			print("enter state book")
			enter_book()
		States.LOADING:
			print("enter state loading")
			enter_loading()
		States.LEVEL01:
			print("enter state level 01")
			enter_level_01()
		States.TELESCOPE01:
			print("enter state telescope1")
			enter_telescope_01()
		States.LEVEL02:
			print("enter state level 02")
			enter_level_02()
		States.TELESCOPE02:
			print("enter state telescope2")
			enter_telescope_02()
		States.LEVEL03:
			print("enter state level 03")
			enter_level_03()
		States.GAMEOVER:
			print("enter state game over")
			enter_gameover()
		States.END:
			print("enter state end")
			enter_end()
			
func exit_state(state):
	match state:
		
		States.MAINMENU:
			exit_main_menu()
		States.BRIEFING:
			exit_briefing()
		States.BOOK:
			exit_book()
		States.LOADING:
			exit_loading()
		States.LEVEL01:
			exit_level_01()
		States.TELESCOPE01:
			exit_telescope_01()
		States.LEVEL02:
			exit_level_02()
		States.TELESCOPE02:
			exit_telescope_02()
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
	
func exit_main_menu():
	main_menu.hide()
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
	level_interface.hide()
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
	arrival_01.show()
	current_level = "res://Scenes/Level01.tscn"
	main_menu.hide()
	level_interface.show()
	get_tree().change_scene_to_file("res://Scenes/Level01.tscn")
	# Additional setup for level 01 state

func exit_level_01():
	level_interface.hide()
	reset_finds()
	# Additional cleanup for level 01 state
func enter_telescope_01():
	
	get_tree().change_scene_to_file("res://Scenes/telescope01.tscn")
	
func exit_telescope_01():
	pass

func enter_level_02():

	current_level = "res://Scenes/Level02.tscn"
	main_menu.hide()
	level_interface.show()
	get_tree().change_scene_to_file("res://Scenes/Level02.tscn")

func exit_level_02():
	level_interface.hide()
	reset_finds()

func enter_telescope_02():
	get_tree().change_scene_to_file("res://Scenes/telescope02.tscn")

func exit_telescope_02():
	pass

func enter_level_03():

	main_menu.hide()
	level_interface.show()
	current_level = "res://Scenes/Level03.tscn"
	get_tree().change_scene_to_file("res://Scenes/Level03.tscn")

func exit_level_03():
	level_interface.hide()
	reset_finds()

func enter_gameover():
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func exit_gameover():
	# Cleanup for game over state
	pass

func enter_end():
	get_tree().change_scene_to_file("res://Scenes/ending.tscn")

func exit_end():
	# Cleanup for end state
	pass


func _on_start_game_pressed():
	change_state(States.BRIEFING)

func _on_level_01_completed():
	
	## TODO pass thourhg book scene
	change_state(States.TELESCOPE01)

func _on_level_02_completed():
	## TODO pass thourhg book scene
	print("can go to level 03")
	change_state(States.TELESCOPE02)

func _on_level_03_completed():
	## TODO pass thourhg book scene
	print("can go to end")
	change_state(States.END)

func _on_gameover():
	change_state(States.GAMEOVER)

func _on_quit_pressed():
	get_tree().quit()


func _process(delta):
	player = get_tree().get_first_node_in_group("player")
	# check if player is aborad and level complete
	if player:
		if player.player_embarked and level_complete:
			print ("passou fase")
			if current_level == "res://Scenes/Level01.tscn":
				_on_level_01_completed()
			elif current_level == "res://Scenes/Level02.tscn":
				_on_level_02_completed()
			elif current_level == "res://Scenes/Level03.tscn":
				_on_level_03_completed()

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
	#prints("fuel collected", fuel_level)
	if fuel_level == 10:
		fuel_full = true
		#prints("tanque cheio")
	check_level_complete()

func _collect_red_mineral():
	wand_level += 1
	## TODO display label powerup
	print("wand level: " + str(wand_level))
	
func _collect_star_fragment():
	check_level_complete()
	star_found = true

func _collect_book():
	check_level_complete()
	book_found = true
	
func reset_finds():
	level_complete = false
	star_found = false
	book_found = false
	fuel_level = 0

func retry_level():
		get_tree().change_scene_to_file(current_level)


func check_level_complete():
	if fuel_full and book_found and star_found:
		level_complete = true
		#print("level complete")
	


func _on_state_checker_timer_timeout():
	#print("state check")
	player = get_tree().get_first_node_in_group("player")
	#print(player)
	if player:
		#print("level complete: " + str(level_complete))
		#print("player emarked: " + str(player.player_embarked))
		state_checker_timer.start()
