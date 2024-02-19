extends ParallaxBackground

@export var scrolling_speed = 50
@onready var mansionBG: Sprite2D = $Mansion;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scroll_offset.x -= scrolling_speed * delta
	var viewportWidth = get_viewport().size.x
	var viewportHeight = get_viewport().size.y
	var scale = viewportWidth / mansionBG.texture.get_size().x

	mansionBG.set_position(Vector2(viewportWidth/2, viewportHeight/2));
	#mansionBG.set_scale(Vector2(scale, scale));
