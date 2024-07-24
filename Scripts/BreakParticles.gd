extends Node2D

@onready var part_life_timer = $PartLifeTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	part_life_timer.start()
	print("break particles born at position: " +str(position))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_part_life_timer_timeout():
	queue_free()
