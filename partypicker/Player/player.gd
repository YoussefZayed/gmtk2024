class_name Player
extends Area2D

@export var stats: Entity : set = set_player_stats

@onready var sprite_2D: Sprite2D = $Sprite2D

func _init() -> void:
	print("PlayerRunning")

func set_player_stats(value: Entity) -> void:
	print("StartingSettingStats")
	
	print("SettingStats")
	update_player()

func update_player() -> void:
	if not stats is Entity:
		return
	if not is_inside_tree():
		await ready
	
	print("SettingSprite")
	sprite_2D.texture = stats.art
