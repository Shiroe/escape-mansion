extends Sprite2D
@onready var canvas_layer: CanvasLayer = $CanvasLayer;
@onready var label: Label = $CanvasLayer/NinePatchRect/Label;

@export_multiline var LabelText = '';

func _ready():
	label.text = LabelText;

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		canvas_layer.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == 'Player':
		canvas_layer.hide()
