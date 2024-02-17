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
	var mat = sprite.get_material();
	mat.set_shader_parameter("light_position", player.global_position)
	mat.set_shader_parameter("light_radius", 128.0)

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
