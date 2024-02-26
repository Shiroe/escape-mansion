extends Node


var MaxPlayerSanity = 100;
var MaxPlayerEnergy = 100;
var PlayerSanity := 100;
var PlayerEnergy := 100;

var isKeyFound = false
var lever1Found = false
var lever2Found = false
var lever3Found = false
var hasWon = false
var bgMusicPlayer: AudioStreamPlayer = AudioStreamPlayer.new();
var bgMusicFile: AudioStreamMP3 = preload("res://assets/bg-music.mp3");
var playerStartingPos: Vector2 = Vector2(1535, 917)

# Called when the node enters the scene tree for the first time.
func _ready():
	bgMusicPlayer.stream = bgMusicFile;
	bgMusicPlayer.finished.connect(func(): bgMusicPlayer.play(0.0))
	add_child(bgMusicPlayer);
	bgMusicPlayer.play();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func reducePlayerEnergy(amount):
	if PlayerEnergy - amount <= 0:
		PlayerEnergy = 0;
		return;
	PlayerEnergy -= amount;
	

func increasePlayerEnergy(amount):
	if PlayerEnergy + amount >= MaxPlayerEnergy:
		PlayerEnergy = MaxPlayerEnergy;
		return;
	PlayerEnergy += amount;


func reducePlayerSanity():
	if hasWon:
		return;

	PlayerSanity -= 10;
	if PlayerSanity <= 0:
		GameOver();
	

func GameOver():
	reset()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn");

func reset():
	PlayerSanity = 100;
	PlayerEnergy = 100;
	isKeyFound = false
	lever1Found = false
	lever2Found = false
	lever3Found = false
	hasWon = false
	
