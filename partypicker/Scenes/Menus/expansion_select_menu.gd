extends Node2D

var expansions = ["Basic Support", "Basic Damage Dealer"]
var honorbound_on = false
var call_of_the_wild_on = false
var rise_of_slayers_on = false
var dark_dealings_on = false
var kings_court_on = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_honorbound_button_pressed() -> void:
	honorbound_on = !honorbound_on


func _on_call_of_the_wild_button_pressed() -> void:
	call_of_the_wild_on = !call_of_the_wild_on


func _on_rise_of_slayers_button_pressed() -> void:
	rise_of_slayers_on = !rise_of_slayers_on


func _on_dark_dealings_button_pressed() -> void:
	dark_dealings_on = !dark_dealings_on


func _on_kings_court_button_pressed() -> void:
	kings_court_on =! kings_court_on


func _on_button_pressed() -> void:
	expansions = ["Basic Support", "Basic Damage Dealer"]
	if honorbound_on:
		expansions.append("HB")
	if call_of_the_wild_on:
		expansions.append("COTW")
	if rise_of_slayers_on:
		expansions.append("ROS")
	if dark_dealings_on:
		expansions.append("DD")
	if kings_court_on:
		expansions.append("KC")
	print(expansions)
	
