class_name CardDeck
extends Resource

signal card_pile_size_changed(cards_amount)

@export var cards: Array[Card] =[]
