extends Control

var children_visible_characters = 0
var mother_visible_characters = 0

signal intro_end

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if $Children/ChildBubble/ChildBubbleText.visible_characters == 0.1:
		$Children/ChildAudioStreamPlayer.play()
	
	if $Mother/MotherBubble/MotherBubbleText.visible_characters == 0.1:
		$Mother/MotherAudioStreamPlayer.play()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	intro_end.emit()
	#get_tree().change_scene_to_file("res://scenes/game.tscn")

		
		
