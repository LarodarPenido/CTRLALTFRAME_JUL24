extends Control


@onready var item_name_label = $ItemNameLabel
@onready var item_description_label = $ItemDescriptionLabel


# Function to update the labels
func update_item_info(item_type: String):
	item_name_label.text = item_type.capitalize()
	item_description_label.text = get_item_description(item_type)

# Dummy function to get item descriptions
func get_item_description(item_type: String) -> String:
	var descriptions = {
		"ship_fuel": "Fuel for the spaceship.",
		"catnip": "Catnip.",
		"red_mineral": "A rare red mineral.",
		"star": "A star imprisoned into a tini device.",
		"book": "A book with ancient knowledge."
	}
	return descriptions.get(item_type, "Unknown item")
