class_name Card
extends Resource

enum Type {ATTACK, DEFEND, HEAL, SUPPORT}
enum Target {LANE_SELF, LANE_ENEMY, LANE_ALL, LANE_CHOICE, ALL_ALLIES, ALL_ENEMIES, EVERYONE}

@export_group("Card Attributes")
@export var name: String
@export var type: Type
@export var target: Target

var energy_cost: int
var physical_damage: int
var magical_damage: int
var physical_block: int
var magical_block: int
var card_draw: int
var card_discard: int
var physical_dealt_increase: int
var magical_dealt_increase: int
var physical_taken_increase: int
var magical_taken_increase: int

func is_single_targeted() -> bool:
	return target == Target.LANE_CHOICE
