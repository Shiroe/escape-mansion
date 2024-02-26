extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var key: Sprite2D = $KeyContainer/key
@onready var keySFXPlayer: AudioStreamPlayer2D = $KeyContainer/KeySFXPlayer;
@onready var lever_1: Sprite2D = $LeversContainer/lever1
@onready var lever_2: Sprite2D = $LeversContainer/lever2
@onready var lever_3: Sprite2D = $LeversContainer/lever3
@onready var leversSFXPlayer: AudioStreamPlayer = $LeversContainer/AudioStreamPlayer;
@onready var key_door: Sprite2D = $keyDoor/keyDoor

@onready var keyDoorAnimationPlayer: AnimationPlayer = $keyDoor/keyDoorAnimationPlayer
@onready var leverDoorAnimationPlayer: AnimationPlayer = $leverDoor/leverDoorAnimationPlayer
@onready var finalDoorAnimationPlayer: AnimationPlayer = $finalDoor/finalDoorAnimationPlayer

@onready var progress_bar: TextureProgressBar = $HUD/VBoxContainer/HBoxContainerSanity/ProgressBar
@onready var energyBar: TextureProgressBar = $HUD/VBoxContainer/HBoxContainerBattery/TextureProgressBar;

@onready var victory: CanvasLayer = $Victory
@onready var victorySFXPlayer: AudioStreamPlayer2D = $VictoryPoint/VictorySFXPlayer


var animation_played = false

func _ready() -> void:
	player.global_position = Game.playerStartingPos

func _process(_delta: float) -> void:
	if Game.lever2Found && Game.lever3Found && !animation_played:
		keyDoorAnimationPlayer.play('open')
		animation_played = true
	
	progress_bar.value = Game.PlayerSanity
	energyBar.value = Game.PlayerEnergy;


func _on_lever_1_area_body_entered(body: Node2D) -> void:
	if body == player:
		lever_1.flip_h = true
		leversSFXPlayer.play();
		Game.lever1Found = true
		leverDoorAnimationPlayer.play('open')

func _on_level_2_area_body_entered(body: Node2D) -> void:
	if body == player:
		lever_2.flip_h = true
		leversSFXPlayer.play();
		Game.lever2Found = true

func _on_level_3_area_body_entered(body: Node2D) -> void:
	if body == player:
		lever_3.flip_h = true
		leversSFXPlayer.play();
		Game.lever3Found = true

func _on_victory_point_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		victorySFXPlayer.play();
		victory.show()
		Game.hasWon = true


func _on_key_area_body_entered(body: Node2D) -> void:
	if body == player:
		Game.isKeyFound = true
		keySFXPlayer.play();
		finalDoorAnimationPlayer.play('open')
		key.queue_free()


