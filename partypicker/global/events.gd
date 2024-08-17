extends Node

# Card-related events
signal card_drag_started(Card_ui: CardUI)
signal card_drag_ended(Card_ui: CardUI)

signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)

signal card_played(card: Card)
