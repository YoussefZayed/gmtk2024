class_name CardUI
extends Control

signal reparent_requested(which_card_ui: CardUI)

@export var card: Card : set = _set_card
@export var char_stats: Entity

@onready var card_art: TextureRect = $Card_art
@onready var target_icon: TextureRect = $MarginContainer/TargetIcon
@onready var mana_cost: Label = $ManaCost
@onready var card_name: Label = $"HBoxContainer/Card Ally Stat Bar/CardName"
@onready var phys_def_num: Label = $"HBoxContainer/Card Ally Stat Bar/CardStats/PhysDef Container/PhysDef Label"
@onready var mag_def_num: Label = $"HBoxContainer/Card Ally Stat Bar/CardStats/MagDef Container/MagDef Label"
@onready var phys_dam_num: Label = $"HBoxContainer/Card Ally Stat Bar/CardStats/PhysDam Container/PhysDam Label"
@onready var mag_dam_num: Label = $"HBoxContainer/Card Ally Stat Bar/CardStats/MagDam Container/MagDam Label"
@onready var phys_vul_num: Label = $"HBoxContainer/Card Ally Stat Bar/CardStats/PhysVul Container/PhysVul Label"
@onready var mag_vul_num: Label = $"HBoxContainer/Card Ally Stat Bar/CardStats/MagVul Container/MagVul Label"
@onready var phys_up_num: Label = $"HBoxContainer/Card Ally Stat Bar/CardStats/PhysUp Container/PhysUp Label"
@onready var mag_up_num: Label = $"HBoxContainer/Card Ally Stat Bar/CardStats/MagUp Container/MagUp Label"
@onready var draw_num: Label = $"HBoxContainer/Card Ally Stat Bar/CardStats/Draw Container/Draw Label"
@onready var heal_num: Label = $"HBoxContainer/Card Ally Stat Bar/CardStats/Heal Container/Heal Label"

@onready var color: ColorRect = $Color
@onready var state: Label = $State
@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var targets: Array[Node] =[]

var parent: Control
var tween: Tween
var playable := true : set = _set_playable
var disabled := false

func _ready() -> void:
	#Events.card_aim_started.connect(_on_card_drag_or_aim_started)
	#Events.card_drag_started.connect(_on_card_drag_or_aim_started)
	#Events.card_drag_ended.connect(_on_card_drag_or_aim_ended)
	#Events.card_aim_ended.connect(_on_card_drag_or_aim_ended)
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
	card_name.text = str(card.name)
	card_art.texture = card.card_art
	
	if card.physical_block > 0:
		phys_def_num.text = str(card.physical_block)
		phys_def_num.get_parent().visible = true
	else:
		phys_def_num.get_parent().visible = false
	
	if card.magical_block > 0:
		mag_def_num.text = str(card.magical_block)
		mag_def_num.get_parent().visible = true
	else:
		mag_def_num.get_parent().visible = false
	
	if card.physical_damage > 0:
		phys_dam_num.text = str(card.physical_damage)
		phys_dam_num.get_parent().visible = true
	else:
		phys_dam_num.get_parent().visible = false
	
	if card.magical_damage > 0:
		mag_dam_num.text = str(card.magical_damage)
		mag_dam_num.get_parent().visible = true
	else:
		mag_dam_num.get_parent().visible = false
	
	if card.physical_taken_increase > 0:
		phys_vul_num.text = str(card.physical_taken_increase)
		phys_vul_num.get_parent().visible = true
	else:
		phys_vul_num.get_parent().visible = false
	
	if card.magical_taken_increase > 0:
		mag_vul_num.text = str(card.magical_taken_increase)
		mag_vul_num.get_parent().visible = true
	else:
		mag_vul_num.get_parent().visible = false
	
	if card.physical_dealt_increase > 0:
		phys_up_num.text = str(card.physical_dealt_increase)
		phys_up_num.get_parent().visible = true
	else:
		phys_up_num.get_parent().visible = false
	
	if card.magical_dealt_increase > 0:
		mag_up_num.text = str(card.magical_dealt_increase)
		mag_up_num.get_parent().visible = true
	else:
		mag_up_num.get_parent().visible = false
	
	if card.card_draw > 0:
		draw_num.text = str(card.card_draw)
		draw_num.get_parent().visible = true
	else:
		draw_num.get_parent().visible = false
	
	if card.health_increase > 0:
		heal_num.text = str(card.health_increase)
		heal_num.get_parent().visible = true
	else:
		heal_num.get_parent().visible = false
	
	match card.target:
		0:
			target_icon.texture = load("res://Assets/Art/Icons/LaneSelf Icon.png")
		1:
			target_icon.texture = load("res://Assets/Art/Icons/LaneEnemy Icon.png")
		2:
			target_icon.texture = load("res://Assets/Art/Icons/LaneAll Icon.png")
		3:
			target_icon.texture = load("res://Assets/Art/Icons/LaneTargeted Icon.png")



func _set_playable(value: bool) -> void:
	playable = value
	if not playable:
		mana_cost.add_theme_color_override("font_color", Color.RED)
		card_art.modulate = Color(1, 1, 1, 0.5)
	else:
		mana_cost.add_theme_color_override("font_color", Color.WHITE)
		card_art.modulate = Color(1, 1, 1, 1)

func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)

func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)

func _on_card_drag_or_aiming_started(used_card: CardUI) -> void:
	if used_card == self:
		return
	
	disabled = true

func _on_card_drag_or_aiming_ended(used_card: CardUI) -> void:
	disabled = false
	self.playable = char_stats.can_play_card(card)

func _on_char_stats_changed() -> void:
		self.playable = char_stats.can_play_card(card)
