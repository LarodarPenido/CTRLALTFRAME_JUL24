extends CharacterBody2D

@export var spell_lifetime = 3.0
@export var spell_speed = 300.0
@export var spell_acceleration = 1.0
@onready var spell_direction: Vector2


@onready var life_timer = $LifeTimer

var direction: Vector2
var current_speed: Vector2

const DESTRUCTIBLE = 1

##VFX
## instantiate sparks on death

func _ready():
	life_timer.start(spell_lifetime)
	current_speed = direction * spell_speed

func _physics_process(delta):
	#var target_speed = spell_direction * spell_speed * delta
	#current_speed = current_speed.lerp(target_speed, spell_acceleration * delta)  
	velocity = current_speed * delta
	move_and_collide(velocity)
	
	var collision_info = move_and_collide(velocity)
	
	if collision_info:
		
		var collider = collision_info.get_collider()
		if collider is TileMap:
			var collision_position = collision_info.get_position()
			var map_position = collider.local_to_map(collision_position)
			var tile_type_id = collider.get_cell_source_id(0, map_position)
			if tile_type_id == DESTRUCTIBLE:
				var atlas_position = collider.get_cell_atlas_coords(0, map_position)
				if atlas_position.y == 0:
					if atlas_position.x == 0:
						collider.erase_cell(0, map_position)
					else:
						atlas_position.x -=1
						collider.set_cell(0, map_position, tile_type_id, atlas_position)
					

		
		
		
		queue_free()



func _on_life_timer_timeout():
	queue_free()
