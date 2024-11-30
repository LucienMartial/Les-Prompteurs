extends Sprite2D

var dragging = false
signal position_dragged(new_position)


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and is_mouse_over():  # Ensure the mouse is over the object
			dragging = true
		elif not event.pressed:
			dragging = false

func _process(delta):
	if dragging:
		global_position = get_global_mouse_position()
		emit_signal("position_dragged", global_position)

func is_mouse_over() -> bool:
	var mouse_pos = get_global_mouse_position()
	var sprite_size = texture.get_size() * scale
	var rect = Rect2(global_position - (sprite_size / 2), sprite_size)
	return rect.has_point(mouse_pos)
