class_name Card
extends Resource

enum Type {ATTACK, DEFEND, HEAL, SUPPORT}
enum Target {LANE_SELF, LANE_ENEMY, LANE_ALL, LANE_CHOICE}
# ALL_ALLIES, ALL_ENEMIES, EVERYONE

@export_group("Card Attributes")
@export var name: String
@export var type: Type
@export var target: Target

@export var energy_cost: int
@export var physical_damage: int
@export var magical_damage: int
@export var physical_block: int
@export var magical_block: int
@export var card_draw: int
@export var card_discard: int
@export var physical_dealt_increase: int
@export var magical_dealt_increase: int
@export var physical_taken_increase: int
@export var magical_taken_increase: int

func is_single_targeted() -> bool:
	return target == Target.LANE_CHOICE
