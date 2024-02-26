extends Node2D

@export var Energy: int = 100;

@onready var sfxPlayer: AudioStreamPlayer = $AudioStreamPlayer;
@onready var sprite: Sprite2D = $Sprite2D;

var isActive: bool = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.material.set_shader_parameter('line_color', Vector4(1.0, 0.1, 0.5, 0.9));
	sprite.material.set_shader_parameter('line_thickness', 0.5);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.is_in_group('player') and isActive:
		isActive = false;
		visible = false;
		sfxPlayer.play();
		Game.increasePlayerEnergy(Energy);
		sfxPlayer.finished.connect(func(): queue_free());
