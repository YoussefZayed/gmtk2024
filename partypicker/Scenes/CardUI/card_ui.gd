class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)

@export var card: Card : set = _set_card
@export var char_stats: Entity

@onready var card_art: TextureRect = $Card_art
@onready var mana_cost: Label = $ManaCost

@onready var color: ColorRect = $Color
@onready var state: Label = $State
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var targets: Array[Node] =[]

var parent: Control
var tween: Tween

func _ready() -> void:
	card_state_machine.init(self)

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans((Tween.TRANS_CIRC)).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)

func play() -> bool:
	var is_played = false
	
	if not card:
		return is_played
	
	is_played = card.play(targets, char_stats, self.get_parent().get_parent(), self.card)
	
	if is_played:
		queue_free()
		return is_played
	else:
		return is_played

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()

func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	mana_cost.text = str(card.energy_cost)
	card_art.texture = card.card_art

func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)

func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)
