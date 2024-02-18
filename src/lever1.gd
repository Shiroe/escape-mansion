extends Sprite2D

@onready var player: CharacterBody2D = $"../Player"
@onready var lever_door: Sprite2D = $"../leverDoor"
var isTurned = false

func _process(delta: float) -> void:
	if isTurned:
		lever_door.rotation = 180.0

func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if not isTurned:
		if body == player:
			self.flip_h = true
			isTurned = true
		
