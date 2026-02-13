class_name Upgrade extends Node2D

var TYPES = ["PLAYER","ABILITY_WOLF","ABILITY_FROG"]

# Ability specifications
var upgrade_name = ""
var type
var speed
var cooldown
var duration
var hitbox_modifier


func _init(upgrade_name:String, type:String, cooldown: float=0, duration:float=0, speed:float=0,hitbox_modifier: float=0):
	self.upgrade_name = upgrade_name
	if type in TYPES:
		self.type = type
	else :
		print("Assigning incorrect type to upgrade. Must be one of " + TYPES)
	if cooldown: self.cooldown = cooldown
	if duration: self.duration = duration
	if speed: self.speed = speed
	if hitbox_modifier: self.hitbox_modifier = hitbox_modifier
	
