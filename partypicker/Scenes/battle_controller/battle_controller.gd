class_name BattleController
extends Node2D

var timeTrial = false
var entities: Array[Entity]
var battles: Array[Battle]
var entitiesDict = {}
var gen_deck = preload("res://characters/generic/generic_deck.tres")
var player_entity_wretch = preload("res://characters/generic/wretch.tres")
var cleric = preload('res://characters/armourer/armourer.tres')
var battleInstanceScene = preload("res://Scenes/BattleInstance/BattleInstance.tscn")
@export var demo_scene = false
@export var demo_scene_battles = 1
@export var timer_time_limit = 100
var turn_num = 0
var turnTimer: Timer
signal player_died(id)
signal battle_ended()


func _ready() -> void:
	if demo_scene and self.get_parent().name != "Game":
		var test_items = testSetup(demo_scene_battles)
		init(test_items[0], test_items[1], timer_time_limit)
	$EndTurn.visible = timeTrial
	$"Start Battle".visible = !timeTrial


func init(all_entities, battles_for_combat, timer_time_amount: int):
	print([all_entities, battles_for_combat, timer_time_amount])
	turnTimer = self.find_child("TurnTimer")
	turnTimer.connect("timeout", on_turnTimer_timeout)
	entities = all_entities as Array[Entity]
	battles = battles_for_combat
	for entity in entities:
		connectToEntity(entity)
		entitiesDict[entity.id] = entity

	createBattles(battles)
	if (not timer_time_amount):
		turnTimer.wait_time = 100
	else:
		turnTimer.wait_time = timer_time_amount
	if timeTrial == true:
		turnTimer.start()
	


func createBattles(battles: Array[Battle]) -> void:
	if battles.size() == 4:
		$_4piece.visible = true
		var battle_instance_parent1 = $_4piece/VBoxContainer2/SubViewportContainer3/SubViewport
		var battle_instance_parent2 = $_4piece/VBoxContainer2/SubViewportContainer4/SubViewport
		var battle_instance_parent3 = $_4piece/VBoxContainer/SubViewportContainer/SubViewport1
		var battle_instance_parent4 = $_4piece/VBoxContainer/SubViewportContainer2/SubViewport
		createBattleInstance(battles[0], battle_instance_parent1)
		createBattleInstance(battles[1], battle_instance_parent2)
		createBattleInstance(battles[2], battle_instance_parent3)
		createBattleInstance(battles[3], battle_instance_parent4)
	elif battles.size() == 3:
		$_3piece.visible = true
		var battle_instance_parent1 = $_3piece/SubViewportContainer/SubViewport1
		var battle_instance_parent2 = $_3piece/SubViewportContainer2/SubViewport
		var battle_instance_parent3 = $_3piece/SubViewportContainer3/SubViewport
		createBattleInstance(battles[0], battle_instance_parent1)
		createBattleInstance(battles[1], battle_instance_parent2)
		createBattleInstance(battles[2], battle_instance_parent3)
	elif battles.size() == 2:
		$_2piece.visible = true
		var battle_instance_parent1 = $_2piece/SubViewportContainer/SubViewport1
		var battle_instance_parent2 = $_2piece/SubViewportContainer2/SubViewport
		createBattleInstance(battles[0], battle_instance_parent1)
		createBattleInstance(battles[1], battle_instance_parent2)
	else:
		$_1v1.visible = true
		createBattleInstance(battles[0], $_1v1)

func createBattleInstance(battle: Battle, parent: Node) -> void:
	var battle_instance = battleInstanceScene.instantiate()
	print(battle_instance)
	battle_instance.init(battle.player, battle.enemy)
	
	parent.add_child(battle_instance)
	
	
	
func testSetup(battle_num):
	var player = Entity.new()
	player.load_from_resource(player_entity_wretch)
	player.id = "1"
	print(player.id)
	print(player.name)
	
	var player2 = Entity.new()
	player2.load_from_resource(cleric)
	player2.id = "2"
	
	var enemy1 = Entity.new()
	enemy1.deck = gen_deck.cards.duplicate()
	enemy1.id = "3"
	enemy1.type = Entity.Type.ENEMY
	enemy1.max_draw = 1
	enemy1.max_energy = 1
	enemy1.draw = 1
	
	var enemy2 = Entity.new()
	enemy2.deck = gen_deck.cards.duplicate()
	enemy2.id = "4"
	enemy2.type = Entity.Type.ENEMY
	enemy2.max_draw = 1
	enemy2.max_energy = 1
	enemy2.draw = 1
	
	var test_battles: Array[Battle] = [Battle.new(player, enemy1)]
	if battle_num > 1:
		for i in range(battle_num - 1):
			test_battles.append(Battle.new(player2, enemy2))
	
	var test_entities: Array[Entity] = [player, player2, enemy1, enemy2]
	battles = test_battles
	entities = test_entities
	
	return [test_entities, test_battles]

func connectToEntity(entity: Entity) -> void:
	entity.card_played.connect(play_card)

func play_card(id: String, card: Card, target: String) -> void:
	print(id)
	var card_player = entitiesDict[id]
	if (card.target == card.Target.LANE_CHOICE) && (target == "" || target == null):
		assert(target != "", "ERROR: You must give target a value.");
	var appliedEntites = []
	
	hero_powers(card_player, card)
	
	if card.target == card.Target.LANE_SELF:
		appliedEntites = [card_player]
	elif card.target == card.Target.LANE_ENEMY:
		for battle in battles:
			if battle.player.id == id:
				appliedEntites.append(battle.enemy)
			elif battle.enemy.id == id:
				appliedEntites.append(battle.player)
	
	elif card.target == card.Target.LANE_ALL:
		for battle in battles:
			if battle.player.id == id:
				appliedEntites.append(battle.enemy)
			elif battle.enemy.id == id:
				appliedEntites.append(battle.player)
		appliedEntites.append(card_player)
	elif card.target == card.Target.LANE_CHOICE:
		appliedEntites.append(entitiesDict[target])
	
	for entity in appliedEntites:
		applyCardToEntity(card_player, card, entity)

	card_player.energy -= card.energy_cost
	checkDeaths()


	
func applyCardToEntity(card_player: Entity, card: Card, entity: Entity) -> void:
	print(["What entity? ->", entity])
	entity.change_physical_block(card.physical_block)
	entity.change_magical_block(card.magical_block)
	entity.physical_dealt_increase += card.physical_dealt_increase
	entity.magical_dealt_increase += card.magical_dealt_increase
	entity.physical_taken_increase += card.physical_taken_increase
	entity.magical_taken_increase += card.magical_taken_increase
	entity.heal_character(card.health_increase)
	for i in range(card.card_draw):
		entity.draw_card()
	if card.magical_damage > 0:
		entity.take_damage((card.magical_damage+card_player.magical_dealt_increase), "magical")
		card_player.magical_dealt_increase = 0
	if card.physical_damage > 0:
		entity.take_damage((card.physical_damage+card_player.physical_dealt_increase), "physical")
		card_player.physical_dealt_increase = 0

func end_turn():
	$EndTurn/VBoxContainer/Button.text = "End Turn"
	$"Start Battle".text = "End Turn"
	for battle in battles:
		if battle.battleEnded:
			hero_lane_won_ability(battle)
			continue
		
		enemy_stat_endturn(battle)
		
		if battle.player.health > 0:
			battle.player.end_turn()
		if (battle.enemy.hand):
			print(battle.enemy.hand[0])
			battle.enemy.play_card(battle.enemy.hand[0], battle.player.id)
		battle.enemy.end_turn()
		
		player_stat_endturn(battle)
		
	checkDeaths()
	#turnTimer.wait_time = max(30, turnTimer.wait_time - 10)
	if timeTrial == true:
		turnTimer.start()

func player_stat_endturn(battle):
	if battle.player.physical_block > 0: # reset block at end of turn
		battle.player.physical_block = 0
	if battle.player.magical_block > 0: # reset block at end of turn
		battle.player.magical_block = 0
	
	if battle.player.physical_taken_increase > 0: # decrement vulnerability by one at end of turn
		battle.player.physical_taken_increase = floor(battle.player.physical_taken_increase/2)
	if battle.player.magical_taken_increase > 0: # decrement vulnerability by one at end of turn
		battle.player.magical_taken_increase = floor(battle.player.magical_taken_increase/2)

func enemy_stat_endturn(battle):
	if battle.enemy.physical_block > 0: # reset block at end of turn
		battle.enemy.physical_block = 0
	if battle.enemy.magical_block > 0: # reset block at end of turn
		battle.enemy.magical_block = 0
	
	if battle.enemy.physical_taken_increase > 0: # decrement vulnerability by one at end of turn
		battle.enemy.physical_taken_increase = floor(battle.enemy.physical_taken_increase/2)
	if battle.enemy.magical_taken_increase > 0: # decrement vulnerability by one at end of turn
		battle.enemy.magical_taken_increase = floor(battle.enemy.magical_taken_increase/2)

func hero_powers(card_player, card: Card):
	card_player.cards_played += 1
	var entity_class = card_player.name
	
	var appliedAllies = [] # need to change this to all allies
	var appliedEnemies = [] # need to change this to all enemies
	
	for battleInstance in battles:
		appliedAllies.append(battleInstance.player)
		appliedEnemies.append(battleInstance.enemy)
	
	match entity_class:
		"Alchemist":
			if card.magical_damage>0:
				for entity in appliedEnemies:
					entity.magical_taken_increase += 1
		"Armourer":
			if card.physical_block>0:
				for entity in appliedAllies:
					entity.change_physical_block(card_player.level)
		"Bard":
			if card.magical_damage>0 or card.physical_damage>0:
				for entity in appliedAllies:
					entity.heal_character(card_player.level)
		"Beast Master":
			for n in card_player.level:
				print("Deal 1 damage to lane enemy")
		"Cleric":
			if card.health_increase>0:
				for entity in appliedAllies:
					entity.heal_character(card_player.level)
		"Fortune Teller":
			if (card_player.cards_played%5) == 0:
				for entity in appliedAllies:
					entity.draw_card()
		"Grenadier":
			if card.physical_damage>0:
				for entity in appliedEnemies:
					entity.take_damage(card_player.level, "physical")
		"Hunter":
			if card.physical_damage>0:
				for entity in appliedEnemies:
					entity.physical_taken_increase += card_player.level
		"Mage":
			if card.magical_damage>0:
				for entity in appliedEnemies:
					entity.take_damage(card_player.level, "magical")
		"Mystic":
			if card.magical_block>0:
				for entity in appliedAllies:
					entity.change_magical_block(card_player.level)

func hero_lane_won_ability(battle):
	print("Ability Cast")
	pass

func checkDeaths():
	for battle in battles:
		if battle.player.health <= 0 && not battle.battleEnded:
			battle.player.energy = 0
			battle.player.discard_hand()
			battle.battleEnded = true
			print("👍👍👍 ENDED")
			battle.player.emit_signal("battleEnded", battle.player.id, true)
			self.emit_signal("player_died", battle.player.id)
		elif battle.enemy.health <= 0:
			battle.player.energy = 0
			battle.player.discard_hand()
			print("ASDASd ENDED")
			battle.battleEnded = true
			battle.player.emit_signal("battleEnded", battle.player.id, false)
	var battle_on_going = false
	for battle in battles:
		if not battle.battleEnded:
			battle_on_going = true
	if (not battle_on_going):
		self.emit_signal("battle_ended")

func _on_button_pressed() -> void:
	end_turn()

func on_turnTimer_timeout() -> void:
	end_turn()
	
func _process(delta: float) -> void:
	var time_rem = turnTimer.time_left
	$"EndTurn/VBoxContainer/Timer Bar/MarginContainer/TimeRemaining".value = time_rem
	$EndTurn/VBoxContainer/TurnTimerLabel.text = "( " + str(round(time_rem)) + " secs)"
