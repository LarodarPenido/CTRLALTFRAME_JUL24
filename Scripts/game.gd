extends Node2D

var wand_level = 1

@onready var post_process = $CanvasLayer/PostProcess
@onready var quake_timer = $QuakeTimer

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
	print("fuel collected")

func _collect_red_mineral():
	print("red min collected")
	
func _collect_star_fragment():
	print("star gotten")

func _collect_book():
	print(" got the book")
	
