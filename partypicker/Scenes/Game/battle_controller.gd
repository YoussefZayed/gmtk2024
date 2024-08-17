extends Node2D


var entities: Array[Entity]
var battles: Array[Battle]
var entitiesDict = {}
var state = "PLAYER_TURN"


func _init() -> void:
	var test_items = testSetup()
	entities = test_items[0]
	battles = test_items[1]
	for entity in entities:
		connectToEntity(entity)
		entitiesDict[entity.id] = entity
	createBattles(battles)
	
func createBattles(battles: Array[Battle]) -> void:
	pass
		

func testSetup():
	var card = Card.new()
	var player = Entity.new([card])
	player.id = "1"
	var player2 = Entity.new([card])
	player2.id = "2"
	var enemy1 = Entity.new([card])
	enemy1.id = "3"
	enemy1.type = Entity.Type.ENEMY
	enemy1.max_draw = 1
	enemy1.max_energy = 1
	enemy1.draw = 1
	
	var enemy2 = Entity.new([card])
	enemy2.id = "4"
	enemy2.type = Entity.Type.ENEMY
	enemy2.max_draw = 1
	enemy2.max_energy = 1
	enemy1.draw = 1
	var test_battles = [Battle.new(player, enemy1), Battle.new(player2, enemy2)]
	var test_entities = [player, player2, enemy1, enemy2]
	return [test_entities, test_battles]

func connectToEntity(entity: Entity) -> void:
	entity.card_played.connect(play_card)

func play_card(id: String, card: Card, target: String) -> void:
	var card_player = entitiesDict[id]
	

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
