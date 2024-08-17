class_name Player
extends Area2D

@export var stats: Entity : set = set_enemy_stats

@onready var sprite_2D: Sprite2D = $Sprite2D

func _init() -> void:
	print("EnemyRunning")

func set_enemy_stats(value: Entity) -> void:
	stats = value.create_instance()
	print("SettingStats")
	update_enemy()

func update_enemy() -> void:
	if not stats is Entity:
		return
	if not is_inside_tree():
		await ready
	
	print("SettingSprite")
	sprite_2D.texture = stats.art
