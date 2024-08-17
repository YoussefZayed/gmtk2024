class_name Entity
extends Resource

signal health_changed(id, new_health)
signal energy_changed(id, new_energy)
signal effect_added(id, effect)
signal effect_removed(id, effect)
signal card_played(id, card, target)
signal turn_ended(id)
signal card_added(id, card)
signal physical_block_changed(id, new_block)
signal magical_block_changed(id, new_block)


enum Type {PLAYER, ENEMY}

@export var id: String = ''
@export var name: String = "Entity"
@export var max_health: int = 100
@export var max_draw: int = 7
@export var draw: int = 4
@export var max_energy: int = 3
@export var base_damage: int = 0
@export var base_defense: int = 0
@export var type: Type = Type.PLAYER
@export var hand: Array[Card] = []
@export var physical_block: int = 0
@export var magical_block: int = 0

var health: int = max_health:
	set(value):
		health = clamp(value, 0, max_health)
		emit_signal("health_changed", id, health)
	get:
		return health

var energy: int = max_energy:
	set(value):
		energy = clamp(value, 0, max_energy)
		emit_signal("energy_changed", id, energy)
	get:
		return energy

var effects: Dictionary = {}
var deck: Array[Card] = []
var discard_pile: Array[Card] = []
var draw_pile: Array[Card] = []


func _init(init_deck: Array[Card]) -> void:
	health = max_health
	energy = max_energy
	self.deck = init_deck
	self.draw_pile = self.deck

func change_physical_block(amount: int) -> void:
	if amount > 0:
		physical_block += amount
	else:
		physical_block = min(0, physical_block + amount)
	emit_signal("physical_block_changed", id, physical_block)

func change_magical_block(amount: int) -> void:
	if amount > 0:
		magical_block += amount
	else:
		magical_block = min(0, magical_block + amount)
	emit_signal("magical_block_changed", id, magical_block)


func take_damage(amount: int) -> void:
	health -= max(0, amount - base_defense)

func heal(amount: int) -> void:
	health += amount

func add_status_effect(effect: String) -> void:
	emit_signal("effect_added", id, effect)

func remove_status_effect(effect: String) -> void:
	emit_signal("effect_removed", id, effect)

func add_card_to_deck(card: Card) -> void:
	deck.append(card)

func draw_card() -> Card:
	if draw_pile.is_empty():
		shuffle_discard_into_draw()
	
	if not draw_pile.is_empty():
		var card = draw_pile.pop_back()
		hand.append(card)
		emit_signal("card_added", id, card)
		return card
	
	return null

func discard_card(card: Card) -> void:
	discard_pile.append(card)

func shuffle_discard_into_draw() -> void:
	draw_pile = discard_pile.duplicate()
	draw_pile.shuffle()
	discard_pile.clear()

func reset_energy() -> void:
	energy = max_energy

func can_play_card(card: Card) -> bool:
	return energy >= card.energy_cost

func play_card(card: Card, target: String) -> void:
	emit_signal("card_played", id, card, target)
	hand.erase(card)
	discard_card(card)

func end_turn() -> void:
	emit_signal("turn_ended", id)
