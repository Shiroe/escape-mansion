extends CharacterBody2D

@export_category('stats')
@export var speed := 60;
@export var chaseSpeed := 120;
@export var isChasing = false;

@onready var pathFollow: PathFollow2D = $".."
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D;
@onready var player: CharacterBody2D = $"../../../CharacterBody2D";

var lastPatrolPosition;
var hasReturnedToLastPatrolPosition = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var lantern: PointLight2D = player.get_node('LanternLight2');
	var light_position = player.global_position;
	var light_radius = 128;

	var distance_to_light = light_position.distance_to(global_position)
		
		# Calculate the transparency based on the distance
	var transparency = clamp((light_radius - distance_to_light) / light_radius, 0.0, 1.0)
		
		# Calculate the visible portion based on the light radius
	var visible_portion = clamp((light_radius - distance_to_light) / light_radius, 0.0, 1.0)
		
		# Set the CanvasModulate property to control transparency
	if lantern.enabled:
		modulate.a = transparency
		# Clip the visible portion using draw_rect
		draw_rect(Rect2(0, 0, 32 * visible_portion, 32), Color(1, 1, 1, 1))
	else:
		modulate.a = 0.0;


func _physics_process(delta):
	if not isChasing:
		if hasReturnedToLastPatrolPosition:
			pathFollow.progress += delta * speed
			lastPatrolPosition = global_position;
		else:
			moveBackToPatrol()
	else:
		hasReturnedToLastPatrolPosition = false;
		var direction = (player.global_position - global_position).normalized();
		velocity = direction * chaseSpeed;
	move_and_slide();
		
func moveBackToPatrol():
	if lastPatrolPosition and not hasReturnedToLastPatrolPosition: 
		if global_position.floor() == lastPatrolPosition.floor():
			hasReturnedToLastPatrolPosition = true;
			velocity = Vector2.ZERO;
		else:
			var direction = global_position.direction_to(lastPatrolPosition).normalized()
			velocity = direction * speed;
