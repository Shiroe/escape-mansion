extends Sprite2D

@onready var player: CharacterBody2D = $"../Player"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		Game.isKeyFound = true
		queue_free()
