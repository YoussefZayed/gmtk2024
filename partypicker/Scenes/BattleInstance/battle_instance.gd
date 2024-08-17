extends Node2D

# need to make this so that it is individual for each instance
#func _notification(what):
#	if what == NOTIFICATION_WM_MOUSE_ENTER:
#		print("enter")
#	elif what == NOTIFICATION_WM_MOUSE_EXIT:
#		print("exit")
		# Here include code to reset all cards into hand using the _on_card_ui_reparent_requested function in hand.gd

var gen_deck = preload("res://characters/generic/generic_deck.tres")
var player: Entity
var enemy: Entity

#func _init(player_entity, enemy_entity) -> void:
#	player  = Entity.new([gen_deck])
#	enemy  = Entity.new([gen_deck])

func init(playerEntity, enemyEntity) -> void:
	player = playerEntity
	enemy = enemyEntity
	print("READY")
	list_hand()

#func create_instance() -> Resource:
	#var enemy: Entity = 

func _ready() -> void:
	pass

func list_hand():
	var hand_node = $BattleUI/MarginContainer/Hand
	print(hand_node.get_children())

func can_play_card(card: Card) -> bool:
	return player.energy >= card.energy_cost
