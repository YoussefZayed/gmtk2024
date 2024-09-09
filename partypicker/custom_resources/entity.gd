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
signal battleEnded(id, player_lost)
signal physical_dealt_increased(id, amount)
signal magical_dealt_increased(id, amount)
signal physical_taken_increased(id, amount)
signal magical_taken_increased(id, amount)
signal card_discarded(id,card)
signal hand_discarded()


enum Type {PLAYER, ENEMY}

var id: String = '':
	set(value):
		id = value
	get:
		return id
@export var name: String = "Entity"
@export var expansion: String = "Basic"
@export var level: int = 1
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
@export var art: Texture
@export_multiline var tool_tip: String

var cards_played = 0

var physical_dealt_increase: int = 0:
	set(value):
		#if value == 0:
			#return
		physical_dealt_increase = value
		emit_signal("physical_dealt_increased", id, physical_dealt_increase)
	get:
		return physical_dealt_increase

var magical_dealt_increase: int = 0:
	set(value):
		#if value == 0:
			#return
		magical_dealt_increase = value
		emit_signal("magical_dealt_increased", id, magical_dealt_increase)
	get:
		return magical_dealt_increase


var physical_taken_increase: int = 0:
	set(value):
		#if value == 0:
			#return
		physical_taken_increase = value
		emit_signal("physical_taken_increased", id, physical_taken_increase)
	get:
		return physical_taken_increase

var magical_taken_increase: int = 0:
	set(value):
		#if value == 0:
			#return
		magical_taken_increase = value
		emit_signal("magical_taken_increased", id, magical_taken_increase)
	get:
		return magical_taken_increase

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
var deck: Array[Card] = []: 
	set(value):
		deck = value
		draw_pile = deck
	get:
		return deck
var discard_pile: Array[Card] = []
var draw_pile: Array[Card] = []


func _init() -> void:
	health = max_health
	energy = max_energy

	
func load_from_resource(resource) -> void:
	print(typeof(resource))
	name = resource.name
	max_health = resource.max_health
	max_draw = resource.max_draw
	draw = resource.draw
	max_energy = resource.max_energy
	base_damage = resource.base_damage
	base_defense = resource.base_defense
	type = resource.type
	art = resource.art
	deck = resource.hand.duplicate()
	print(["here ->", resource.hand])

func heal_character(amount: int, activeChars)-> void:
	health += amount
	if name == "Zealot":
		physical_dealt_increase += 2
	if name == "Monk":
		for entity in activeChars[0]:
			entity.change_physical_block(level)
			entity.change_magical_block(level)

func change_physical_block(amount: int) -> void:
	if amount == 0:
		return
	if amount > 0:
		physical_block += amount
		if name == "Knight":
			physical_dealt_increase += 2
		if name == "Artificer":
			magical_dealt_increase += 2
	else:
		physical_block = min(0, physical_block + amount)
	
	emit_signal("physical_block_changed", id, physical_block)

func change_magical_block(amount: int) -> void:
	if amount == 0:
		return
	if amount > 0:
		magical_block += amount
		if name == "Knight":
			physical_dealt_increase += 2
		if name == "Artificer":
			magical_dealt_increase += 2
	else:
		magical_block = min(0, magical_block + amount)
	emit_signal("magical_block_changed", id, magical_block)

func take_damage(amount: int, attack_type: String) -> void:
	var post_amount
	if attack_type == "physical":
		post_amount = max(0, (amount+physical_taken_increase-physical_block))
		change_physical_block(-min(amount+physical_taken_increase, physical_block))
	elif attack_type == "magical":
		post_amount = max(0, (amount+magical_taken_increase-magical_block))
		change_magical_block(-min(amount+magical_taken_increase, magical_block))
	health -= post_amount
	health = max(0, health)

	
func heal(amount: int) -> void:
	health += amount
	health = min(health, max_health)

func shuffle_deck() -> void:
	deck.shuffle()


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
		#print([self.id, self.hand, "Drawn Card"])
		return card
	
	return null

func draw_hand() -> void:
	for i in range(draw):
		draw_card()

func discard_hand() -> void:
	self.emit_signal("hand_discarded")
	for card in hand:
		discard_card(card)
	hand.clear()


func discard_card(card: Card) -> void:
	#print([self.id, self.hand, "Discard Card"])
	emit_signal("card_discarded", id, card)
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
	energy = max_energy
	discard_hand()
	draw_pile.shuffle()
	draw_hand()
	print([id, health])


func battle_ended(player_lost: bool) -> void:
	emit_signal("battleEnded", player_lost)
