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

var flashConeAngle: float = 45.0;
var ray_count: int = 5


func _ready() -> void:
	pass

func _physics_process(delta):
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
		#FlashLightArea.monitorable = true;
		#var collidingNode = doRayCastingMagic();
		
		flashMarker.rotation = get_angle_to(get_global_mouse_position())
		flashLightGCD.start(0.5);
		flashLightAnimation.play("flash", -1, 1);
		flashLightAnimation.animation_finished.connect(
			func(): 
				isFlashLightOn = false;
				FlashLightArea.monitorable = false;
		)


#func doRayCastingMagic():
	#ray1.force_raycast_update();
	#ray2.force_raycast_update();
	#ray3.force_raycast_update();
	#ray4.force_raycast_update();
	#ray5.force_raycast_update();
	#
	#var coll1 = ray1.get_collider();
	#var coll2 = ray2.get_collider();
	#var coll3 = ray3.get_collider();
	#var coll4 = ray4.get_collider();
	#var coll5 = ray5.get_collider();
#
	#if ray1.is_colliding() or ray2.is_colliding() or ray3.is_colliding() or ray4.is_colliding() or ray5.is_colliding():
		#coll1 = ray1.get_collider();
		#coll2 = ray2.get_collider();
		#coll3 = ray3.get_collider();
		#coll4 = ray4.get_collider();
		#coll5 = ray5.get_collider();
		#
	#if coll1 and coll1.name == "Ghost":
		#print('coll-1 found ghost');
		#return coll1
		#
	#if coll2 and coll2.name == "Ghost":
		#print('coll-2 found ghost');
		#return coll2;
		#
	#if coll3 and coll3.name == "Ghost":
		#print('coll-3 found ghost');
		#return coll3;
	#
	#if coll4 and coll4.name == "Ghost":
		#print('coll-4 found ghost')
		#return coll4;
	#
	#if coll5 and coll5.name == "Ghost":
		#print('coll-5 found ghost');
		#return coll5;


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
		hurt_gcd.start(1)
