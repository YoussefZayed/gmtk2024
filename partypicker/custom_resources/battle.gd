class_name Battle
extends Resource

@export var player: Entity
@export var enemy: Entity
@export var battleEnded: bool = false

func _init(player_entity: Entity, enemy_entity: Entity) -> void:
	self.player = player_entity
	self.enemy = enemy_entity
	self.battleEnded = false
