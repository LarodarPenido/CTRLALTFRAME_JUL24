extends Node2D

@onready var post_process = $CanvasLayer/PostProcess
@onready var quake_timer = $QuakeTimer



## Progression
var wand_level = 1


## Win Conditions
var player_embarked = false
var fuel_level = 0
var star_found = false
var book_found = false


var fuel_full = false


## Cutscenes


## Levels
const LEVEL_01 = preload("res://Scenes/Level01.tscn")

## UI toggles
@onready var story = $CanvasLayer/Story
@onready var main_menu = $CanvasLayer/MainMenu
@onready var level_interface = $CanvasLayer/LevelInterface


func _ready():
	story.hide()
	level_interface.hide()
	
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
	star_found = false
	book_found = false
	fuel_level = 0

func _on_start_game_pressed():
	main_menu.hide()
	get_tree().change_scene_to_file("res://Scenes/Level01.tscn")
	
func go_to_level_02():
	pass

func go_to_level_03():
	pass

func _on_quit_pressed():
	get_tree().quit()
