extends CharacterBody2D

@export_category('stats')
@export var speed := 60;
@export var chaseSpeed := 120;
@export var isChasing = false;
@export_enum("loop", "linear") var patrol_type = "loop"
var direction = 1

@onready var pathFollow: PathFollow2D = $".."
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D;
@onready var player: CharacterBody2D = $"../../../Player";
#@onready var ray: RayCast2D = $RayCast2D;

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
			if patrol_type == 'loop':
				pathFollow.progress += delta * speed
			else:
				if direction == 1:
					if pathFollow.progress_ratio == 1:
						direction = 0
					else:
						pathFollow.progress += delta * speed
				else:
					if pathFollow.progress_ratio == 0:
						direction = 1
					else:
						pathFollow.progress_ratio -= delta * speed
			lastPatrolPosition = global_position;
		else:
			moveBackToPatrol()
	else:
		hasReturnedToLastPatrolPosition = false;
		var direction = (player.global_position - global_position).normalized();
		velocity = direction * lerp(speed, chaseSpeed, 0.8);
	move_and_slide();
		
func moveBackToPatrol():
	if lastPatrolPosition and not hasReturnedToLastPatrolPosition: 
		if global_position.floor() == lastPatrolPosition.floor():
			hasReturnedToLastPatrolPosition = true;
			velocity = Vector2.ZERO;
		else:
			var direction = global_position.direction_to(lastPatrolPosition).normalized()
			velocity = direction * speed;


func detectPlayer():
	# TODO: fix position checking, values are wrong
	var distance = global_position.distance_to(player.global_position);
	print('Distance to player', distance);
	if distance <= 64:
		isChasing = true;
	if distance >= 73:
		isChasing = false;
	


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		isChasing = true;


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		isChasing = false;


func _on_hit_area_area_entered(area):
	if area.name == "FlashLightArea":
		print('hit by flashlight')
