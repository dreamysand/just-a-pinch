extends Node

signal dialogue_shaked
signal dialogue_changed(text: String)

@export var sfx_grandma_mumble: AudioStream = preload("res://assets/sounds/sfx_grandma_mumble.wav")
@export var sfx_grandma_angry: AudioStream = preload("res://assets/sounds/sfx_grandma_angry.wav")

var dialogue_database := {
	"start": {
		"normal": [
			"Just add a pinch of everything, darling!",
			"Follow your heart... or whatever is in front of you.",
			"Cooking is an art, dear! Don't overthink it."
		],
		"angry": [
			"ARE YOU TRYING TO BURN MY KITCHEN AGAIN?!",
			"WHAT ARE YOU DOING?! JUST COOK PROPERLY!",
			"MY BLOOD PRESSURE IS RISING, DARLING!"
		]
	},
	"flour": {
		"normal": [
			"A little flour makes it fluffy!",
			"Whoa, easy with the flour, dear.",
			"That looks like a decent amount of flour."
		],
		"angry": [
			"THAT IS TOO MUCH FLOUR! ARE WE MAKING CONCRETE?!",
			"STOP DUSTING EVERYTHING IN FLOUR!",
			"I CAN'T BREATHE FROM ALL THIS FLOUR POWDER!"
		]
	},
	"sugar": {
		"normal": [
			"Sugar, sugar, sugar! Sweet enough yet?",
			"Just a spoonful of sugar helps the cake go down!",
			"A sweet touch for my sweet child."
		],
		"angry": [
			"YOU'RE GOING TO GIVE US ALL DIABETES!",
			"DO YOU WANT AN ANT INFESTATION?! TOO MUCH SUGAR!",
			"STOP POURING SUGAR LIKE IT'S FREE!"
		]
	},
	"egg": {
		"normal": [
			"Crack it nicely! Don't drop the shell!",
			"A fresh egg makes all the difference.",
			"One egg down, good job darling."
		],
		"angry": [
			"ANOTHER EGG?! THERE ARE SHELLS EVERYWHERE!",
			"STOP CRACKING EGGS ON MY CLEAN COUNTER!",
			"ARE WE MAKING AN OMELETTE OR A CAKE?!"
		]
	},
	"salt": {
		"normal": [
			"Just a pinch of salt... perfect balance.",
			"Salt enhances the sweetness, good choice.",
			"A pinch is enough, dear."
		],
		"angry": [
			"THIS IS NOT SEAWATER! STOP ADDING SALT!",
			"MY KIDNEYS HURT JUST WATCHING YOU ADD SALT!",
			"THAT IS WAY MORE THAN A PINCH!"
		]
	},
	"mix": {
		"normal": [
			"Keep going, darling! Put some muscle into it!",
			"Mix it smooth and nice.",
			"Stir rhythmically, like a dancing spoon."
		],
		"angry": [
			"STOP MIXING! YOU'RE CREATING A VORTEX!",
			"THE BATTER IS FLYING ALL OVER THE WALLS!",
			"WHY ARE YOU STILL STIRRING?! ARE YOU TRYING TO DRILL TO CHINA?!"
		]
	},
	"baking": {
		"normal": [
			"Put it in the oven. Watch the timer!",
			"Baking takes patience, dear.",
			"Let the heat do its magic!"
		],
		"angry": [
			"IT'S SMOKING! TURN OFF THE OVEN NOW!",
			"DO YOU HEAR THE FIRE ALARM YET?!",
			"YOU ARE CREATING A CHARCOAL BRICK IN MY OVEN!"
		]
	},
	"serving": {
		"normal": [
			"Time to serve it to Grandma!",
			"Mmm... let's see what you cooked for me!",
			"Bon appétit, darling!"
		],
		"angry": [
			"FINALLY! JUST HAND IT OVER BEFORE SOMETHING EXPLODES!",
			"IS THIS EVEN EDIBLE?! BRING IT HERE!",
			"I SCARED TO TRY THIS, BUT GIVE IT TO ME!"
		]
	}
}

func show_dialogue(category: String) -> void:
	if dialogue_database.has(category):
		_play_voice_and_trigger_effects()
		
		var mode = "angry" if GameManager.is_angry else "normal"
		var lines = dialogue_database[category][mode]
		var line = lines[randi() % lines.size()]
		dialogue_changed.emit(line)

func show_line(text: String) -> void:
	_play_voice_and_trigger_effects()
	dialogue_changed.emit(text)

func _play_voice_and_trigger_effects() -> void:
	if GameManager.is_angry:
		AudioManager.play_sfx(sfx_grandma_angry)
		dialogue_shaked.emit()
	else:
		AudioManager.play_sfx(sfx_grandma_mumble)
