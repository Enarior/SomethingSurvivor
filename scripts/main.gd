extends Control

@export var intro_scene: PackedScene
@export var game_scene: PackedScene

var intro
var game

# debug
var play_intro = false

const MAX_VOLUME = -10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SoundPool/IntroAudioStreamPlayer.play()
	
	if play_intro:
		intro = intro_scene.instantiate()
		add_child(intro)
		
		intro.intro_end.connect(_on_intro_intro_end)
	else:
		start_game_scene()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_intro_intro_end():
	intro.queue_free()
	start_game_scene()

func _on_game_game_started():
	audio_transition($SoundPool/IntroAudioStreamPlayer, $SoundPool/GameAudioStreamPlayer)

		
func audio_transition(current_audio_stream_player: AudioStreamPlayer, new_audio_stream_player: AudioStreamPlayer):
	# Fade-out / Fade-in audio transition
	var tween = create_tween()
	
	tween.tween_property(current_audio_stream_player, "volume_db",-60,0.75)
	new_audio_stream_player.volume_db = -40
	new_audio_stream_player.play()
	tween.tween_property(new_audio_stream_player, "volume_db",MAX_VOLUME, 0.5)

func start_game_scene():
	game = game_scene.instantiate()
	add_child(game)
	
	game.game_started.connect(_on_game_game_started)
	game.game_over.connect(_on_game_game_over)
	
	game.new_game()
	
func _on_game_game_over():
		audio_transition($SoundPool/GameAudioStreamPlayer, $SoundPool/IntroAudioStreamPlayer)
