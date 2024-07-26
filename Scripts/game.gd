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
	print("star gotten")

func _collect_book():
	print(" got the book")
	
