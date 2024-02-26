extends CharacterBody2D

@export_category('stats')
@export var speed: int = 80;
@export var chaseSpeed: int = 120;
@export var isChasing: bool = false;
@export var CUSTOM_DEBUG_AREA: bool = false;

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
var hit_pos: Array = [];
var target
var laser_color = Color.WHITE
var vis_color = Color(.867, .91, .247, 0.1)
var detect_radius = 100

@onready var lantern: PointLight2D;
var lightPosition;
var lightRadius;
var distanceToLight;
var transparency;
var visiblePortion

# Called when the node enters the scene tree for the first time.
func _ready():
	lantern = player.get_node('LanternNode/LanternLight2');


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# update variables for _draw function
	lightPosition = player.global_position;
	lightRadius = lantern.texture.get_width() / 2.0;
	distanceToLight = lightPosition.distance_to(global_position)
	transparency = clamp((lightRadius - distanceToLight) / lightRadius, 0.0, 1.0)
	# Calculate the visible portion based on the light radius
	visiblePortion = clamp((lightRadius - distanceToLight) / lightRadius, 0.0, 1.0)
	queue_redraw();


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
					var hasPlayerView = isSeeingPlayer()
					if hasPlayerView and hasPlayerView.playerPos and hasPlayerView.distance <= detect_radius:
						moveTo(hasPlayerView.playerPos)
					else:
						hasAggro = false
						isChasing = false
			else:
				moveBackToPatrol();
		
		move_and_slide();


func _draw() -> void:
	# ----------------------------------------------------------------------------
	# Calculate the transparency based on the distance
	# Set the CanvasModulate property to control transparency
	if lantern.enabled and isSeeingPlayer():
		modulate.a = transparency
		# Clip the visible portion using draw_rect
		#draw_rect(Rect2(0, 0, 32 * visiblePortion, 32), Color(1, 1, 1, 1))
	else:
		modulate.a = 0.0;
	# ----------------------------------------------------------------------------
	
	if CUSTOM_DEBUG_AREA:
		draw_circle(Vector2(), detect_radius, vis_color)
		if target and hit_pos.is_empty() == false:
			for hit in hit_pos:
				draw_line(Vector2(), (hit - global_position), laser_color)



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



func isSeeingPlayer():
	var space_state = get_world_2d().direct_space_state
	var rays = 36
	var angleStep = 2 * PI / rays
	hit_pos.clear();

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
				# result.position is the intersection point
				# result.collider is the reference to Player node

				hit_pos.append(result.position);
				lastKnownPlayerPos = result.collider.global_position

				var distance = global_position.distance_to(lastKnownPlayerPos)
				hasAggro = true
				return { 'playerPos': lastKnownPlayerPos, 'distance': distance }
	return null


func moveTo(pos):
	navigationAgent.target_position = pos
	var navDirection = (navigationAgent.get_next_path_position() - global_position).normalized()
	velocity = navDirection * lerp(speed, chaseSpeed, 0.8);


func stun():
	if stunGCD.is_stopped():
		collision_shape_2d.disabled = true
		stunGCD.start(1.2)
		isStunned = true


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		target = body
		if isSeeingPlayer():
			isChasing = true


func _on_stun_gcd_timeout() -> void:
	isStunned = false
	collision_shape_2d.disabled = false

