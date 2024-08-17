class_name Card
extends Resource

enum Type {ATTACK, DEFEND, HEAL, SUPPORT}
enum Target {LANE_SELF, LANE_ENEMY, LANE_ALL, LANE_CHOICE, ALL_ALLIES, ALL_ENEMIES, EVERYONE}

@export_group("Card Attributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var energy_cost: int

func is_single_targeted() -> bool:
	return target == Target.LANE_CHOICE
