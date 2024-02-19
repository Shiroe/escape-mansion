extends Sprite2D

@onready var player: CharacterBody2D = $"../Player"
@onready var animation_player: AnimationPlayer = $"../StaticBody2D/AnimationPlayer"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		Game.isKeyFound = true
		animation_player.play('open')
		queue_free()
