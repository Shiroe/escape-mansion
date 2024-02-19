extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var lever_2: Sprite2D = $lever2
@onready var lever_3: Sprite2D = $lever3
@onready var key_door: Sprite2D = $keyDoor
@onready var animation_player: AnimationPlayer = $StaticBody2D3/AnimationPlayer
@onready var progress_bar: ProgressBar = $HUD/ProgressBar
@onready var victory: CanvasLayer = $Victory

var animation_played = false

func _ready() -> void:
	player.global_position = Game.playerStartingPos

func _process(delta: float) -> void:
	if Game.lever2Found && Game.lever3Found && !animation_played:
		animation_player.play('open')
		animation_played = true
	
	progress_bar.value = Game.PlayerSanity

func _on_level_2_area_body_entered(body: Node2D) -> void:
	if body == player:
		lever_2.flip_h = true
		Game.lever2Found = true


func _on_level_3_area_body_entered(body: Node2D) -> void:
	if body == player:
		lever_3.flip_h = true
		Game.lever3Found = true


func _on_victory_point_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		victory.show()
		Game.hasWon = true
