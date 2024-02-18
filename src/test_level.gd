extends Node2D

@onready var final_door: Sprite2D = $finalDoor
@onready var player: CharacterBody2D = $Player
@onready var lever_2: Sprite2D = $lever2
@onready var lever_3: Sprite2D = $lever3
@onready var key_door: Sprite2D = $keyDoor

func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	if Game.isKeyFound:
		final_door.rotation = 0
	if Game.lever3Found and Game.lever2Found:
		key_door.rotation = 180


func _on_level_2_area_body_entered(body: Node2D) -> void:
	if body == player:
		lever_2.flip_h = true
		Game.lever2Found = true


func _on_level_3_area_body_entered(body: Node2D) -> void:
	if body == player:
		lever_3.flip_h = true
		Game.lever3Found = true


