extends Node

var PlayerSanity := 100;
var Battery := 100;

var isKeyFound = false
var lever2Found = false
var lever3Found = false
var bgMusicPlayer: AudioStreamPlayer = AudioStreamPlayer.new();
var bgMusicFile: AudioStreamMP3 = preload("res://assets/bg-music.mp3");


# Called when the node enters the scene tree for the first time.
func _ready():
	bgMusicPlayer.stream = bgMusicFile;
	bgMusicPlayer.finished.connect(func(): bgMusicPlayer.play(0.0))
	add_child(bgMusicPlayer);
	bgMusicPlayer.play();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func reducePlayerSanity():
	PlayerSanity -= 10;
	if PlayerSanity <= 0:
		GameOver();
	


func GameOver():
	PlayerSanity = 100;
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn");
