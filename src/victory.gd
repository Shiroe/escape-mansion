extends CanvasLayer
@onready var player: CharacterBody2D = $"../Player"



func _on_play_btn_pressed() -> void:
	Game.reset()
	self.hide()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
