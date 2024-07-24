extends Node2D

#var spawn_chance = 0.0
#
#
#var destructibleCount = 0
#
#@export var tilemap: TileMap
#

@export var destructible_tile_id = 1
@export var collectable_scene = preload("res://Scenes/Collectable.tscn")
@export var break_particles_scene = preload("res://Scenes/break_particles.tscn")


var total_initial_destructible_tiles = 0
var total_destructible_tiles = 0
var items_spawned = {
	"ship_fuel": 0,
	"catnip": 0,
	"red_mineral": 0,
	"star": 0,
	"book": 0
}

var required_items = {
	"ship_fuel": 10,
	"catnip": 3,
	"red_mineral": 5,
	"star": 1,
	"book": 1
}

func _ready():
	count_total_destructible_tiles()

func count_total_destructible_tiles():
	total_destructible_tiles = 0
	total_initial_destructible_tiles = 0
	var tilemap = get_parent().get_node("TileMap")
	var used_rect = tilemap.get_used_rect()
	for x in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
		for y in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
			var map_position = Vector2(x, y)
			var tile_type_id = tilemap.get_cell_source_id(0, map_position)
			if tile_type_id == destructible_tile_id:
				var atlas_position = tilemap.get_cell_atlas_coords(0, map_position)
				if atlas_position.y == 0:
					total_destructible_tiles += 1
					total_initial_destructible_tiles += 1
	#print("Total destructible tiles:", total_destructible_tiles)



func handle_tile_destruction(map_position, collision_position):
	var tilemap = get_parent().get_node("TileMap")
	tilemap.erase_cell(0, map_position)
	total_destructible_tiles -= 1
	count_total_destructible_tiles()
	spawn_collectable(collision_position)
	spawn_sparks(collision_position)
	
	print(items_spawned)
	print(required_items)

func spawn_collectable(_position):
	var spawn_item = choose_item_to_spawn()
	if spawn_item != "":
		#print(spawn_item, "spawned at:", _position)
		items_spawned[spawn_item] += 1
		var collectable = collectable_scene.instantiate()
		collectable.global_position = _position
		collectable.set("item_type", spawn_item)  ## BUG just marked bug to check later
		get_tree().root.add_child(collectable)
	else:
		pass
		#print("No item spawned at:", _position)

func choose_item_to_spawn():
	var total_chance = 0.0
	var spawn_chances = {}
	
	# Calculate the total spawn chance for all items
	for item_name in required_items.keys():
		var chance = get_spawn_chance(item_name)
		spawn_chances[item_name] = chance
		total_chance += chance
	
	# Check if there's any chance to spawn an item
	if total_chance <= 0:
		return ""
	
	# Generate a random value between 0 and 1
	var random_value = randf() * total_chance
	#print("Random value:", random_value, "Total chance:", total_chance)
	
	# Determine which item to spawn based on random value and accumulated chance
	var accumulated_chance = 0.0
	for item_name in spawn_chances.keys():
		accumulated_chance += spawn_chances[item_name]
		#print("Item:", item_name, "Accumulated chance:", accumulated_chance)
		if random_value < accumulated_chance:
			return item_name
		else:
			return ""
	#var total_chance = 0.0
	#var spawn_chances = {}
	#for item_name in required_items.keys():
		#var chance = get_spawn_chance(item_name)
		#spawn_chances[item_name] = chance
		#total_chance += chance
	#
	#if total_chance <= 0:
		#return ""
	#
	#var random_value = randf() * total_chance
	#prints("random value: " + str(random_value), "total chance: " + str(total_chance))
	#var accumulated_chance = 0.0
	#print("accumulated chance: " + str(accumulated_chance))
	#for item_name in spawn_chances.keys():
		#accumulated_chance += spawn_chances[item_name]
		#if random_value < accumulated_chance:
			#return item_name
	#return ""

func get_spawn_chance(item_name):
	var remaining_tiles = total_destructible_tiles
	var items_needed = required_items[item_name] - items_spawned[item_name]
	if items_needed <= 0:
		return 0
	
	# Calculate the base chance based on remaining tiles
	var base_chance = max(0.0, (1.0 - float(remaining_tiles) / total_initial_destructible_tiles) * .01)
	var shenaninage = 1.0 - float(remaining_tiles) / total_initial_destructible_tiles * .01
	print(shenaninage)
	# Ensure that the chance increases as the number of remaining tiles decreases
	var required_remaining_chance = float(items_needed) / remaining_tiles
	
	# Combine the base chance with the required chance, ensuring it does not exceed 1.0
	var total_chance = min(base_chance + required_remaining_chance, 1.0)
	
	#print("Item:", item_name, "Base chance:", base_chance, "Required chance:", required_remaining_chance, "Total chance:", total_chance)
	return total_chance

	#randomize()
	#var remaining_tiles = total_destructible_tiles
	#var items_needed = required_items[item_name] - items_spawned[item_name]
	#if items_needed <= 0:
		#return 0
#
	## Calculate the base chance based on remaining tiles
	#var base_chance = (1.0 - float(remaining_tiles) / total_initial_destructible_tiles) * 0.01
	## Ensure that the total chance increases as the number of remaining tiles decreases
	#var required_remaining_chance = float(items_needed) / remaining_tiles
	##print(items_needed)
#
	## Ensure the chance does not exceed 1.0
	#var total_chance = min(base_chance + required_remaining_chance, 1.0)
	#
	#print("Item:", item_name,"Total chance:", total_chance)
	#return total_chance


func spawn_sparks(_position):
	var sparks = break_particles_scene.instantiate()
	get_tree().root.add_child(sparks)
	sparks.global_position = _position
