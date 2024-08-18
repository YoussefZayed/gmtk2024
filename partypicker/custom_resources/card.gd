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
@export var card_art: Texture
@export_multiline var tooltip_text: String

func is_single_targeted() -> bool:
	return target == Target.LANE_CHOICE

func _get_targets(targets: Array[Node], node) -> Array[Node]:
	if not targets:
		return []
	
	var tree := targets[0]
	var unithold = node.find_child("UnitsUI")
	print(unithold)
	
	match target:
		Target.LANE_SELF:
			return [unithold.find_child("Player")]
		Target.LANE_ENEMY:
			return [unithold.find_child("Enemy")]
		Target.LANE_ALL:
			return [unithold.find_child("Player"), unithold.find_child("Enemy")]
		_:
			return []

func play(targets: Array[Node], char_stats: Entity, node, card) -> bool:
	
	var output_targets
	
	if is_single_targeted():
		output_targets = [targets[0]]
	else:
		output_targets = _get_targets(targets, node)
	
	var battle = output_targets[0].get_parent().get_parent().get_parent()
	var is_played = false
	
	if battle.player.energy < card.energy_cost:
		return is_played
	
	is_played = true
	
	battle.player.play_card(card, battle.enemy.id)
	
	Events.card_played.emit(self)
	
	return is_played
