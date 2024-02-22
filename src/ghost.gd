extends CharacterBody2D

@export_category('stats')
@export var speed := 60;
@export var chaseSpeed := 120;
@export var isChasing = false;
@export_enum("loop", "linear") var patrol_type = "loop"
var direction = 1

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var pathFollow: PathFollow2D = $".."
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D;
@onready var player: CharacterBody2D = $"../../../Player";
@onready var navigationAgent : NavigationAgent2D = $NavigationAgent2D
@onready var stunGCD: Timer = $StunGCD

var lastKnownPlayerPos;
var lastPatrolPosition;
var hasReturnedToLastPatrolPosition = true;
var hasAggro = false
var isStunned = false;
var hit_pos
var target
var laser_color = Color.WHITE
var vis_color = Color(.867, .91, .247, 0.1)
var detect_radius = 128
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
	if isStunned:
		sprite.play("stun");
		return;
	else:
		sprite.play("idle")
		if not isChasing:
			if hasReturnedToLastPatrolPosition:
				doPatrol(delta)
			else:
				moveBackToPatrol()
		else:
			hasReturnedToLastPatrolPosition = false;
			
			moveTo(lastKnownPlayerPos)
			if hasAggro:
				if navigationAgent.is_navigation_finished():
					var hasPlayerView = isSeeingPlayer(lastKnownPlayerPos)
					if hasPlayerView and hasPlayerView.playerPos and hasPlayerView.distance <= detect_radius:
						moveTo(hasPlayerView.playerPos)
					else:
						hasAggro = false
						isChasing = false
			else:
				moveBackToPatrol();

		move_and_slide();

func moveBackToPatrol():
	if lastPatrolPosition and not hasReturnedToLastPatrolPosition: 
		if navigationAgent.is_target_reached():
			global_position = lerp(global_position, lastPatrolPosition, 1.0)
			hasReturnedToLastPatrolPosition = true
			velocity = Vector2.ZERO
		else:
			moveTo(lastPatrolPosition)


func doPatrol(delta):
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
				pathFollow.progress -= delta * speed
	lastPatrolPosition = global_position;


func detectPlayer():
	# TODO: fix position checking, values are wrong
	var distance = global_position.distance_to(player.global_position);
	
	print('Distance to player', distance);
	if distance <= 64:
		isChasing = true;
	if distance >= 73:
		isChasing = false;
	


func isSeeingPlayer(playerPos):
	var space_state = get_world_2d().direct_space_state
	var rays = 36
	var angleStep = 2 * PI / rays
	hit_pos = []
	
	for i in rays:
		var angle = i * angleStep
		var rayStart = global_position
		var rayEnd = Vector2(cos(angle), sin(angle)) * detect_radius
		var rayEndGlobal = rayStart + rayEnd
		var query = PhysicsRayQueryParameters2D.create(rayStart, rayEndGlobal,
			collision_mask, [self])
		var result = space_state.intersect_ray(query)
		if result and result.collider:
			if result.collider.is_in_group('player'):
				lastKnownPlayerPos = result.collider.position
				var distance = global_position.distance_to(lastKnownPlayerPos)
				hasAggro = true
				return { 'playerPos': lastKnownPlayerPos, 'distance': distance}

	return null


func _draw() -> void:
	draw_circle(Vector2(), detect_radius, vis_color)
	if target:
		for hit in hit_pos:
			draw_circle((hit - position).rotated(-rotation), 5, laser_color)
			draw_line(Vector2(), (hit - position).rotated(-rotation), laser_color)


func moveTo(pos):
	navigationAgent.target_position = pos
	var navDirection = (navigationAgent.get_next_path_position() - global_position).normalized()
	velocity = navDirection * lerp(speed, chaseSpeed, 0.8);


func _on_area_2d_body_entered(body):
	target = body
	if body.name == "Player":
		if isSeeingPlayer(body.global_position):
			isChasing = true


func stun():
	#collision_shape_2d.call_deferred("set", "disabled", true)
	collision_shape_2d.disabled = true
	stunGCD.start(1.2)
	isStunned = true


func _on_stun_gcd_timeout() -> void:
	isStunned = false
	collision_shape_2d.disabled = false
	#collision_shape_2d.call_deferred("set", "disabled", false)
