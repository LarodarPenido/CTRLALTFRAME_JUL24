extends Area2D

### igid bodies launched up on ready?

## audio


@onready var clear_timer = $ClearTimer



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body is Player:
		## Pickup effects
		## deduct from stack
		## add progress to fuel/wand upgrade / star fragment
		## play sound
		clear_timer.start()
		
		


func _on_clear_timer_timeout():
	queue_free()
