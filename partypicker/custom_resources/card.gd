class_name Card
extends Resource

enum Type {ATTACK, DEFEND, HEAL, SUPPORT}
enum Target {LANE_SELF, LANE_ENEMY, LANE_ALL, LANE_CHOICE}
# ALL_ALLIES, ALL_ENEMIES, EVERYONE

@export_group("Card Attributes")
@export var name: String
@export var type: Type
@export var target: Target

@export var energy_cost: int = 1
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

func is_single_targeted() -> bool:
	return target == Target.LANE_CHOICE
