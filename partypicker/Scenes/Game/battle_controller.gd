extends Node2D


var entities: Array[Entity]
var battles: Array[Battle]
var entitiesDict = {}
var gen_deck = preload("res://characters/generic/generic_deck.tres")
var player_entity_wretch = preload("res://characters/generic/wretch.tres")
var battleInstanceScene = preload("res://Scenes/BattleInstance/BattleInstance.tscn")


func _ready() -> void:
	var test_items = testSetup()
	for entity in entities:
		connectToEntity(entity)
		entitiesDict[entity.id] = entity
		entity.draw_hand()
	createBattles(battles)

func find_child_by_name(parent: Node, child_name: String) -> Node:
	return parent.find_child(child_name, true, false);
	
func createBattles(battles: Array[Battle]) -> void:
	var battle_instance_parent1 = $HBoxContainer/SubViewportContainer/SubViewport1
	var battle_instance_parent2 =  $HBoxContainer/SubViewportContainer2/SubViewport
	print(battle_instance_parent1 )
	print(battle_instance_parent2)
	
	if battles.size() >= 2:
		createBattleInstance(battles[0], battle_instance_parent1)
		createBattleInstance(battles[1], battle_instance_parent2)

func createBattleInstance(battle: Battle, parent: Node) -> void:
	var battle_instance = battleInstanceScene.instantiate()
	print(battle_instance)
	battle_instance.init(battle.player, battle.enemy)
	parent.add_child(battle_instance)
	
		
func testSetup():
	var player = Entity.new() 
	player.load_from_resource(player_entity_wretch)
	player.id = "1"
	print(player.id)
	print(player.name)
	
	var player2 = Entity.new()
	player2.deck = gen_deck.cards.duplicate()
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
	
	var test_battles: Array[Battle] = [Battle.new(player, enemy1), Battle.new(player2, enemy2)]
	var test_entities: Array[Entity] = [player, player2, enemy1, enemy2]
	battles = test_battles
	entities = test_entities
	
	return [test_entities, test_battles]

func connectToEntity(entity: Entity) -> void:
	entity.card_played.connect(play_card)

func play_card(id: String, card: Card, target: String) -> void:
	var card_player = entitiesDict[id]
	if (card.target == card.Target.LANE_CHOICE) && (target == "" || target == null):
		assert(target != "", "ERROR: You must give target a value.");
	var appliedEntites = []
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
		applyCardToEntity(card, entity)

	card_player.energy -= card.energy_cost
	checkDeaths()

	
func applyCardToEntity(card: Card, entity: Entity) -> void:
	entity.change_physical_block(card.physical_block)
	entity.change_magical_block(card.magical_block)
	entity.physical_dealt_increase += card.physical_dealt_increase
	entity.magical_dealt_increase += card.magical_dealt_increase
	entity.physical_taken_increase += card.physical_taken_increase
	entity.magical_taken_increase += card.magical_taken_increase
	entity.health += card.health_increase
	for i in range(card.card_draw):
		entity.draw_card()
	if card.magical_damage > 0:
		entity.take_damage(card.magical_damage, "magical")
	if card.physical_damage > 0:
		entity.take_damage(card.physical_damage, "physical")

func end_turn():
	for battle in battles:
		if battle.battleEnded:
			continue
		battle.player.end_turn()
		print(battle.enemy.hand[0])
		battle.enemy.play_card(battle.enemy.hand[0], battle.player.id)
		battle.enemy.end_turn()
	checkDeaths()

func checkDeaths():
	for battle in battles:
		if battle.player.health <= 0:
			battle.player.energy = 0
			battle.player.discard_hand()
			battle.battleEnded = true
			battle.player.emit_signal("battleEnded", battle.player.id, true)
		elif battle.enemy.health <= 0:
			battle.player.energy = 0
			battle.player.discard_hand()
			battle.battleEnded = true
			battle.player.emit_signal("battleEnded", battle.player.id, false)
	

func _on_button_pressed() -> void:
	end_turn()
