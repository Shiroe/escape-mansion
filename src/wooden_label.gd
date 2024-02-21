extends Sprite2D
@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		canvas_layer.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == 'Player':
		canvas_layer.hide()
