extends Node2D

var current_direction_index = 0  # Index actuel de la direction
var direction_index_size = 8;
signal direction_changed(index)

func _ready():
	position = global_position
	var hbox = $HBoxContainer
	for button in hbox.get_children():
		button.connect("pressed", Callable(self, "_on_button_pressed").bind(button))

func _on_button_pressed(button):
	var button_text = button.text
	if button_text == ">":
		current_direction_index = (current_direction_index + 1) % direction_index_size
	elif button_text == "<":
		current_direction_index = (current_direction_index - 1 + direction_index_size) % direction_index_size
	else:
		return

	emit_signal("direction_changed", current_direction_index)
