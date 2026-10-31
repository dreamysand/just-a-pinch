extends Node2D

@onready var stage_label: Label = $MarginContainer/MainLayout/Header/StageLabel
@onready var dialogue_label: RichTextLabel = $MarginContainer/MainLayout/Body/GrandmaPanel/VBoxContainer/DialogueLabel
@onready var cake_visual: TextureRect = $MarginContainer/MainLayout/Body/CookingArea/CakeVisual
@onready var grandma_portrait: TextureRect = $MarginContainer/MainLayout/Body/GrandmaPanel/VBoxContainer/GrandmaPortrait

@onready var flour_button: TextureButton = $MarginContainer/MainLayout/Body/ItemPanel/FlourButton
@onready var sugar_button: TextureButton = $MarginContainer/MainLayout/Body/ItemPanel/SugarButton
@onready var egg_button: TextureButton = $MarginContainer/MainLayout/Body/ItemPanel/EggButton
@onready var salt_button: TextureButton = $MarginContainer/MainLayout/Body/ItemPanel/SaltButton
@onready var oven_button: TextureButton = $MarginContainer/MainLayout/Body/ItemPanel/OvenButton
@onready var mix_button: TextureButton = $MarginContainer/MainLayout/Body/ItemPanel/MixButton

@onready var baking_progress_bar: ProgressBar = $MarginContainer/MainLayout/Footer/ActionPanel/BakingProgressBar
@onready var continue_button: Button = $MarginContainer/MainLayout/Footer/ContinueButton

@export var bgm_kitchen: AudioStream = preload("res://assets/sounds/kitchen_bgm.mp3") 

@export var sfx_flour: AudioStream = preload("res://assets/sounds/sfx_flour.wav")
@export var sfx_sugar: AudioStream = preload("res://assets/sounds/sfx_sugar_salt.wav")
@export var sfx_egg: AudioStream = preload("res://assets/sounds/sfx_egg.wav")
@export var sfx_salt: AudioStream = preload("res://assets/sounds/sfx_sugar_salt.wav")
@export var sfx_mix: AudioStream = preload("res://assets/sounds/sfx_mix.wav")
@export var sfx_oven_click: AudioStream = preload("res://assets/sounds/sfx_oven_toggle.wav")
@export var sfx_oven_tick: AudioStream = preload("res://assets/sounds/sfx_oven_1.wav")
@export var sfx_oven_alarm: AudioStream = preload("res://assets/sounds/sfx_oven_2.wav")

@onready var main_layout: VBoxContainer = $MarginContainer/MainLayout

var last_baking_second: int = 0
var alarm_played: bool = false
var has_warned_baking: bool = false

func _ready() -> void:
	DialogueManager.dialogue_changed.connect(_on_dialogue_changed)
	DialogueManager.dialogue_shaked.connect(shake_screen)
	
	flour_button.pressed.connect(_on_flour_pressed)
	sugar_button.pressed.connect(_on_sugar_pressed)
	egg_button.pressed.connect(_on_egg_pressed)
	salt_button.pressed.connect(_on_salt_pressed)
	oven_button.pressed.connect(_on_oven_pressed)
	mix_button.pressed.connect(_on_mix_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	
	AudioManager.play_bgm(bgm_kitchen)
	
	DialogueManager.show_dialogue("start")
	update_ui()

func _process(delta: float) -> void:
	if GameManager.current_stage == GameManager.Stage.BAKING and GameManager.oven_running:
		GameManager.baking_time += delta
		baking_progress_bar.value = GameManager.baking_time
		
		var current_second = int(GameManager.baking_time)
		
		if current_second > last_baking_second and current_second < 15:
			last_baking_second = current_second
			AudioManager.play_sfx(sfx_oven_tick, 0.05)
			
		if GameManager.baking_time >= 15.0:
			if not alarm_played:
				alarm_played = true
				AudioManager.play_sfx(sfx_oven_alarm, 0.0)
				DialogueManager.show_line("IT'S BURNING! TURN IT OFF!")
		elif GameManager.baking_time >= 8.0:
			if not has_warned_baking:
				has_warned_baking = true
				DialogueManager.show_dialogue("baking")
		
		update_ui()

func _on_dialogue_changed(text: String) -> void:
	dialogue_label.text = text

func _on_flour_pressed() -> void:
	GameManager.add_flour()
	AudioManager.play_sfx(sfx_flour)
	
	if GameManager.flour_amount > 4 or GameManager.is_angry:
		shake_button(flour_button)
	
	DialogueManager.show_dialogue("flour")
	update_ui()

func _on_sugar_pressed() -> void:
	GameManager.add_sugar()
	AudioManager.play_sfx(sfx_sugar)
	
	if GameManager.sugar_amount > 4 or GameManager.is_angry:
		shake_button(sugar_button)
		
	DialogueManager.show_dialogue("sugar")
	update_ui()

func _on_egg_pressed() -> void:
	GameManager.add_egg()
	AudioManager.play_sfx(sfx_egg)
	
	if GameManager.egg_amount > 4 or GameManager.is_angry:
		shake_button(egg_button)
		
	DialogueManager.show_dialogue("egg")
	update_ui()

func _on_salt_pressed() -> void:
	GameManager.add_salt()
	AudioManager.play_sfx(sfx_salt)
	
	if GameManager.salt_amount > 4 or GameManager.is_angry:
		shake_button(salt_button)
		
	DialogueManager.show_dialogue("salt")
	update_ui()

func _on_mix_pressed() -> void:
	GameManager.mix_it()
	AudioManager.play_sfx(sfx_mix)
	shake_button(mix_button)
	
	DialogueManager.show_dialogue("mix")
	update_ui()

func _on_oven_pressed() -> void:
	GameManager.toggle_oven()
	AudioManager.play_sfx(sfx_oven_click)
	
	if not GameManager.oven_running:
		alarm_played = false
		has_warned_baking = false
		
	oven_button.texture_normal = load("res://assets/art/oven_on.png") if GameManager.oven_running else load("res://assets/art/oven_off.png")
	update_ui()

func _on_continue_pressed() -> void:
	if GameManager.current_stage == GameManager.Stage.SERVING:
		get_tree().change_scene_to_file("res://scenes/result_screen.tscn")
	else:
		GameManager.next_stage()
		_update_dialogue_for_new_stage()
		update_ui()

func _update_dialogue_for_new_stage() -> void:
	match GameManager.current_stage:
		GameManager.Stage.MIXING:
			DialogueManager.show_dialogue("mix")
		GameManager.Stage.BAKING:
			DialogueManager.show_dialogue("baking")
		GameManager.Stage.SERVING:
			DialogueManager.show_dialogue("serving")

func check_bgm_gimmick() -> void:
	AudioManager.set_bgm_panic_mode(GameManager.is_angry)
	
func update_ui() -> void:
	update_cake_visual()
	update_grandma_expression()
	check_bgm_gimmick()
	
	match GameManager.current_stage:
		GameManager.Stage.INGREDIENTS:
			stage_label.text = "Stage 1: Ingredients"
			flour_button.disabled = false
			sugar_button.disabled = false
			egg_button.disabled = false
			salt_button.disabled = false
			oven_button.disabled = true
			mix_button.visible = false
			baking_progress_bar.visible = false
			continue_button.disabled = !can_continue()
			
		GameManager.Stage.MIXING:
			stage_label.text = "Stage 2: Mixing"
			flour_button.disabled = true
			sugar_button.disabled = true
			egg_button.disabled = true
			salt_button.disabled = true
			oven_button.disabled = true
			mix_button.visible = true
			baking_progress_bar.visible = false
			continue_button.disabled = !can_continue()

		GameManager.Stage.BAKING:
			stage_label.text = "Stage 3: Baking"
			mix_button.visible = false
			oven_button.disabled = false
			baking_progress_bar.visible = true
			continue_button.disabled = !can_continue()

		GameManager.Stage.SERVING:
			stage_label.text = "Stage 4: Serving"
			oven_button.disabled = true
			continue_button.text = "SERVE CAKE!"
			continue_button.disabled = false

func update_cake_visual() -> void:
	match GameManager.current_stage:
		GameManager.Stage.INGREDIENTS:
			if (GameManager.flour_amount + GameManager.sugar_amount + GameManager.egg_amount + GameManager.salt_amount) == 0:
				cake_visual.texture = load("res://assets/art/bowl_empty.png")
			else:
				cake_visual.texture = load("res://assets/art/bowl_ingredients.png")
				
		GameManager.Stage.MIXING:
			if GameManager.mixing_time < 6.0:
				cake_visual.texture = load("res://assets/art/dough_lumpy.png")
			elif GameManager.mixing_time < 12.0:
				cake_visual.texture = load("res://assets/art/dough_smooth.png")
			else:
				cake_visual.texture = load("res://assets/art/dough_overmixed.png")
				
		GameManager.Stage.BAKING:
			if GameManager.baking_time < 5.0:
				cake_visual.texture = load("res://assets/art/oven_raw.png")
			elif GameManager.baking_time < 15.0:
				cake_visual.texture = load("res://assets/art/oven_baking.png")
			else:
				cake_visual.texture = load("res://assets/art/oven_burnt.png")

func update_grandma_expression() -> void:
	if GameManager.is_angry:
		grandma_portrait.texture = load("res://assets/art/grandma_angry.png")
	elif GameManager.current_stage == GameManager.Stage.SERVING:
		grandma_portrait.texture = load("res://assets/art/grandma_happy.png")
	else:
		grandma_portrait.texture = load("res://assets/art/grandma_neutral.png")
		
func shake_button(btn: Control) -> void:
	var tween = create_tween()
	var original_pos = btn.position
	tween.tween_property(btn, "position", original_pos + Vector2(randf_range(-8, 8), randf_range(-8, 8)), 0.05)
	tween.tween_property(btn, "position", original_pos, 0.05)

func shake_screen(intensity: float = 10.0) -> void:
	var tween = create_tween()
	var original_pos = main_layout.position
	
	for i in range(6):
		var offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		tween.tween_property(main_layout, "position", original_pos + offset, 0.04)
	
	tween.tween_property(main_layout, "position", original_pos, 0.02)
			
func can_continue() -> bool:
	match GameManager.current_stage:
		GameManager.Stage.INGREDIENTS:
			return GameManager.flour_amount > 0 or GameManager.sugar_amount > 0 or GameManager.egg_amount > 0
		GameManager.Stage.MIXING:
			return GameManager.mixing_time >= 0.0
		GameManager.Stage.BAKING:
			return GameManager.baking_time > 0.0
		GameManager.Stage.SERVING:
			return true
	return false
