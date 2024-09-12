extends Node2D

var gen_deck = preload("res://characters/generic/generic_deck.tres")
var player: Entity
var enemy: Entity

#func _init(player_entity, enemy_entity) -> void:
#	player  = Entity.new([gen_deck])
#	enemy  = Entity.new([gen_deck])

func init(playerEntity, enemyEntity) -> void:
	player = playerEntity
	player.connect("card_added",add_player_card)
	player.connect("hand_discarded",discard_player_hand)
	$UnitsUI/MarginContainer/Player/Sprite2D.texture = player.art
	$"BattleStatsUI/MarginContainer/MarginContainer/InstanceStats Container/Player Stat Bar/Player".text = player.name
	enemy = enemyEntity
	enemy.connect("card_added",set_enemy_card)
	$UnitsUI/MarginContainer/Enemy/Sprite2D.texture = enemy.art
	$"BattleStatsUI/MarginContainer/MarginContainer/InstanceStats Container/Enemy Stat Bar/Enemy".text = enemy.name
	print("READY")
	list_hand()
	player.heal(0)
	enemy.heal(0)
	
func set_enemy_card(id,card):
	var enemyIntent = $"BattleUI/Intent Margin/EnemyIntent"
	enemyIntent.card = card
	for childNode in enemyIntent.get_children():
		childNode.visible = false
	enemyIntent.find_child("HBoxContainer").visible = true
	enemyIntent.visible = true
	
func add_player_card(id,card):
	var new_card = $BattleUI/MarginContainer/CardUI.duplicate()
	new_card.card = card
	
	$BattleUI/MarginContainer/Hand.add_child(new_card)
	$BattleUI/MarginContainer/Hand.something_else()
	for child in $BattleUI/MarginContainer/Hand.get_children():
		child.set_visible(true)

func discard_player_hand():
	for child in $BattleUI/MarginContainer/Hand.get_children():
		child.queue_free()

#func create_instance() -> Resource:
	#var enemy: Entity = 

func _ready() -> void:
	pass

func list_hand():
	var hand_node = $BattleUI/MarginContainer/Hand
	print(hand_node.get_children())

func can_play_card(card: Card) -> bool:
	return player.energy >= card.energy_cost

func _process(delta):
	update_scordeboard()

func update_scordeboard():
	var player_stat_bar = self.find_child("Player Stat Bar")
	player_stat_bar.find_child("Health Label").text = str(player.health)
	player_stat_bar.find_child("Energy Label").text = str(player.energy)
	
	player_stat_bar.find_child("PhysDef Label").text = str(player.physical_block)
	if player_stat_bar.find_child("PhysDef Label").text == "0":
		player_stat_bar.find_child("PhysDef Container").visible = false
	else:
		player_stat_bar.find_child("PhysDef Container").visible = true
	
	player_stat_bar.find_child("MagDef Label").text = str(player.magical_block)
	if player_stat_bar.find_child("MagDef Label").text == "0":
		player_stat_bar.find_child("MagDef Container").visible = false
	else:
		player_stat_bar.find_child("MagDef Container").visible = true
	
	player_stat_bar.find_child("PhysVul Label").text = str(player.physical_taken_increase)
	if player_stat_bar.find_child("PhysVul Label").text == "0":
		player_stat_bar.find_child("PhysVul Container").visible = false
	else:
		player_stat_bar.find_child("PhysVul Container").visible = true
	
	player_stat_bar.find_child("MagVul Label").text = str(player.magical_taken_increase)
	if player_stat_bar.find_child("MagVul Label").text == "0":
		player_stat_bar.find_child("MagVul Container").visible = false
	else:
		player_stat_bar.find_child("MagVul Container").visible = true
	
	player_stat_bar.find_child("PhysUp Label").text = str(player.physical_dealt_increase)
	if player_stat_bar.find_child("PhysUp Label").text == "0":
		player_stat_bar.find_child("PhysUp Container").visible = false
	else:
		player_stat_bar.find_child("PhysUp Container").visible = true
	
	player_stat_bar.find_child("MagUp Label").text = str(player.magical_dealt_increase)
	if player_stat_bar.find_child("MagUp Label").text == "0":
		player_stat_bar.find_child("MagUp Container").visible = false
	else:
		player_stat_bar.find_child("MagUp Container").visible = true
	
	var enemy_stat_bar = self.find_child("Enemy Stat Bar")
	
	enemy_stat_bar.find_child("Health Label").text = str(enemy.health)
	enemy_stat_bar.find_child("Energy Label").text = str(enemy.max_energy)
	
	enemy_stat_bar.find_child("PhysDef Label").text = str(enemy.physical_block)
	if enemy_stat_bar.find_child("PhysDef Label").text == "0":
		enemy_stat_bar.find_child("PhysDef Container").visible = false
	else:
		enemy_stat_bar.find_child("PhysDef Container").visible = true
	
	enemy_stat_bar.find_child("MagDef Label").text = str(enemy.magical_block)
	if enemy_stat_bar.find_child("MagDef Label").text == "0":
		enemy_stat_bar.find_child("MagDef Container").visible = false
	else:
		enemy_stat_bar.find_child("MagDef Container").visible = true
	
	enemy_stat_bar.find_child("PhysVul Label").text = str(enemy.physical_taken_increase)
	if enemy_stat_bar.find_child("PhysVul Label").text == "0":
		enemy_stat_bar.find_child("PhysVul Container").visible = false
	else:
		enemy_stat_bar.find_child("PhysVul Container").visible = true
	
	enemy_stat_bar.find_child("MagVul Label").text = str(enemy.magical_taken_increase)
	if enemy_stat_bar.find_child("MagVul Label").text == "0":
		enemy_stat_bar.find_child("MagVul Container").visible = false
	else:
		enemy_stat_bar.find_child("MagVul Container").visible = true
	
	#if player.energy == 0:
		#$BattleUI/MarginContainer/HIDEHAND.set_visible(true)
	#else:
		#$BattleUI/MarginContainer/HIDEHAND.set_visible(false)
	if player.health == 0:
		$CanvasLayer/CenterContainer/Lost.visible= true
		$CanvasLayer/CenterContainer/Lost/Label.text = player.name + " Has Died"
	elif enemy.health == 0:
		$CanvasLayer/CenterContainer/Lost.visible= true
		$CanvasLayer/CenterContainer/Lost/Label.text = player.name + " has killed the enemy"
