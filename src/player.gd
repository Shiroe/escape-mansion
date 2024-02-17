extends CharacterBody2D


@onready var animation: AnimatedSprite2D = $AnimatedSprite2D;
@onready var lantern: PointLight2D = $LanternLight;
@onready var lanternOuter: PointLight2D = $LanternLight2;
@onready var flashMarker: Marker2D = $Marker2D;
@onready var flashLight: PointLight2D = $Marker2D/FlashLight;
@onready var flashLightAnimation: AnimationPlayer = $Marker2D/FlashLight/AnimationPlayer;
@onready var flashLightGCD: Timer = $Marker2D/FlashLight/Timer;

@export var SPEED: float = 200.0

var isLanternOn: bool = false;
var isFlashLightOn: bool = false;


func _physics_process(delta):
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
		flashMarker.rotation = get_angle_to(get_global_mouse_position())
		flashLightGCD.start(0.5);
		flashLightAnimation.play("flash", -1, 1);


func handleInput():
	var moveDirection = Input.get_vector("left", "right", "forward", "backwards");
	velocity = moveDirection * SPEED;
	
func updateAnimation():
	if velocity.length() == 0:
		animation.play("idle");
	else:
		animation.play("run");
		
	if velocity.x < 0: animation.flip_h = true;
	if velocity.x > 0: animation.flip_h = false;
	
	
	





