extends ParallaxBackground

@export var scrolling_speed = 50
#@onready var mansionBG: Sprite2D = $Mansion;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scroll_offset.x -= scrolling_speed * delta
