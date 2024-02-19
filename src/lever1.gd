extends Sprite2D

@onready var player: CharacterBody2D = $"../Player"
@onready var lever_door: Sprite2D = $"../leverDoor"
@onready var animation_player: AnimationPlayer = $"../StaticBody2D2/AnimationPlayer"
var isTurned = false


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if not isTurned:
		if body == player:
			self.flip_h = true
			isTurned = true
			animation_player.play('open')
		
