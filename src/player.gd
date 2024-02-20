extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D;
@onready var lantern: PointLight2D = $LanternLight;
@onready var lanternOuter: PointLight2D = $LanternLight2;
@onready var flashMarker: Marker2D = $Marker2D;
@onready var flashLight: PointLight2D = $Marker2D/FlashLight;
@onready var flashLightAnimation: AnimationPlayer = $Marker2D/FlashLight/AnimationPlayer;
@onready var flashLightGCD: Timer = $Marker2D/FlashLight/Timer;
@onready var hurt_gcd: Timer = $HurtGCD
@onready var hurtAnimation: AnimationPlayer = $AnimationPlayer

@export var SPEED: float = 200.0

@export var isLanternOn: bool = false;
@export var isFlashLightOn: bool = false;

@onready var FlashLightArea: Area2D = $Marker2D/FlashLight/FlashLightArea;

@onready var ray1: RayCast2D = $Marker2D/FlashRayCast1;
@onready var ray2: RayCast2D = $Marker2D/FlashRayCast2;
@onready var ray3: RayCast2D = $Marker2D/FlashRayCast3;
@onready var ray4: RayCast2D = $Marker2D/FlashRayCast4;
@onready var ray5: RayCast2D = $Marker2D/FlashRayCast5;

var rays: Array[RayCast2D] = [] 

var flashConeAngle: float = 45.0;
var ray_count: int = 5


func _ready() -> void:
	rays = [ray1, ray2, ray3, ray4, ray5]


func _physics_process(_delta):
	if Game.hasWon:
		animation.play('idle')
		return
	
	handleInput();


	if Input.is_action_just_pressed("mouse_right_click"):
		lantern.enabled = !lantern.enabled;
		lanternOuter.enabled = !lanternOuter.enabled;
		
	if Input.is_action_just_pressed("mouse_left_click"):
		doFlash();
	
	move_and_slide();
	updateAnimation();
	
	
func doFlash():
	if not flashLight.enabled and flashLightGCD.is_stopped():
		isFlashLightOn = true;
		flashMarker.rotation = get_angle_to(get_global_mouse_position())
		flashLightGCD.start(0.5);
		flashLightAnimation.play("flash")

		for ray in rays:
			ray.enabled = true
			ray.force_raycast_update()
			if ray.is_colliding():
				var collider = ray.get_collider()
				if collider.is_in_group('ghost'):
					collider.stun()

func handleInput():
	var moveDirection = Input.get_vector("left", "right", "forward", "backwards");
	velocity = moveDirection * SPEED;
	
func updateAnimation():
	if hurt_gcd.is_stopped():
		hurtAnimation.stop()
		if velocity.length() == 0:
			animation.play("idle");
		else:
			animation.play("run");
	else:
		hurtAnimation.play('hurt', 1, 2.0)
		#animation.self_modulate = lerp(Color(1,1,1,0), Color(1,1,1,1), 0.1)
		
	if velocity.x < 0: animation.flip_h = true;
	if velocity.x > 0: animation.flip_h = false;


func _on_area_2d_body_entered(body):
	if body.is_in_group('ghost') and hurt_gcd.is_stopped():
		Game.reducePlayerSanity();
		hurt_gcd.start(0.5)


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	isFlashLightOn = false;
	for ray in rays:
		ray.enabled = false

