extends Control

@export var intro_scene: PackedScene
@export var game_scene: PackedScene

var intro
var game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SoundPool/IntroAudioStreamPlayer.play()
	
	intro = intro_scene.instantiate()
	add_child(intro)
	
	intro.intro_end.connect(_on_intro_intro_end)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_intro_intro_end():
	intro.queue_free()
	game = game_scene.instantiate()
	add_child(game)
	
	game.game_started.connect(_on_game_game_started)

func _on_game_game_started():
	if $SoundPool/IntroAudioStreamPlayer.playing:
		$SoundPool/IntroAudioStreamPlayer.stop()
	$SoundPool/GameAudioStreamPlayer.play()
	
