class_name Relic
extends Resource

enum Rarity {Common, Rare, Epic, Legendary, Cursed}

@export var public_name: String = "Relic"
@export var private_name: String = "Relic of X"
@export var relic_type: String = "Relic"
@export var expansion: String = "Basic"
@export var value: int = 0

@export var energy_cost: int = 0
@export var physical_damage: int = 0
@export var magical_damage: int = 0
@export var physical_block: int = 0
@export var magical_block: int = 0
@export var card_draw: int = 0
@export var card_discard: int = 0
@export var physical_dealt_increase: int = 0
@export var magical_dealt_increase: int = 0
@export var physical_taken_increase: int = 0
@export var magical_taken_increase: int = 0
@export var health_increase: int = 0
@export var public_texture: Texture
@export var private_texture: Texture
@export_multiline var tooltip_text: String

func identify() -> void:
	public_name = private_name
