extends TextureButton

var dragging := false
var click_offset := Vector2.ZERO

var origin_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - click_offset

func _on_button_down() -> void:
	dragging = true
	click_offset = get_global_mouse_position() - position
	origin_position = position

func _on_button_up() -> void:
	if dragging:
		var success: bool = %GameManager.handle_dropped_object(global_position)
		if(success):
			queue_free()
		else:
			dragging = false
			click_offset = Vector2.ZERO
			position = origin_position
			
