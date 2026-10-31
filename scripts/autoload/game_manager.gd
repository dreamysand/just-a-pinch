extends Node

enum Stage { INGREDIENTS, MIXING, BAKING, SERVING }

var current_stage: Stage = Stage.INGREDIENTS
var flour_amount: int = 0
var sugar_amount: int = 0
var egg_amount: int = 0
var salt_amount: int = 0

var mixing_time: float = 0.0
var baking_time: float = 0.0
var mess_level: int = 0
var oven_running: bool = false
var is_angry: bool = mess_level >= 8 or baking_time >= 15.0

func _process(_delta: float) -> void:
	is_angry = mess_level >= 8 or baking_time >= 15.0
	
func add_flour() -> void:
	flour_amount += 2
	mess_level += 1

func add_sugar() -> void:
	sugar_amount += 2
	mess_level += 1

func add_egg() -> void:
	egg_amount += 1
	mess_level += 1

func add_salt() -> void:
	salt_amount += 1

func mix_it() -> void:
	mixing_time += 2.0
	if mixing_time >= 12.0:
		mess_level += 2

func toggle_oven() -> void:
	oven_running = !oven_running

func next_stage() -> void:
	oven_running = false
	if current_stage < Stage.SERVING:
		current_stage = (current_stage + 1) as Stage

func evaluate_cake() -> String:
	if baking_time >= 15.0:
		return "burnt"
	if is_perfect():
		return "perfect"
	if mess_level >= 8:
		return "favorite"
	return "soup"

func is_perfect() -> bool:
	return (flour_amount == 4 and sugar_amount == 4 and 
			egg_amount == 2 and salt_amount == 1 and 
			mixing_time >= 6.0 and mixing_time <= 8.0 and 
			baking_time >= 8.0 and baking_time < 15.0)

func reset_game() -> void:
	current_stage = Stage.INGREDIENTS
	flour_amount = 0
	sugar_amount = 0
	egg_amount = 0
	salt_amount = 0
	mixing_time = 0.0
	baking_time = 0.0
	mess_level = 0
	oven_running = false
