extends CharacterBody2D

@export var spell_lifetime = 3.0
@export var spell_speed = 300.0
@export var spell_acceleration = 1.0
@onready var spell_direction: Vector2


@onready var life_timer = $LifeTimer

var direction: Vector2
var current_speed: Vector2



##VFX
## instantiate sparks on death

func _ready():
	life_timer.start(spell_lifetime)
	current_speed = direction * spell_speed

func _process(delta):
	#var target_speed = spell_direction * spell_speed * delta
	#current_speed = current_speed.lerp(target_speed, spell_acceleration * delta)  
	velocity = current_speed * delta
	move_and_collide(velocity)


func _on_life_timer_timeout():
	queue_free()


func _on_collision_shape_2d_body_entered(body):
	queue_free()


func _on_collision_shape_2d_area_entered(area):
	queue_free()
