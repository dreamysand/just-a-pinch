extends Control

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var cake_illustration: TextureRect = $VBoxContainer/CakeIllustration
@onready var grandma_comment_label: RichTextLabel = $VBoxContainer/GrandmaCommentLabel
@onready var try_again_button: Button = $VBoxContainer/TryAgainButton

func _ready() -> void:
	try_again_button.pressed.connect(_on_try_again_pressed)
	display_result(GameManager.evaluate_cake())

func display_result(ending_type: String) -> void:
	match ending_type:
		"burnt":
			title_label.text = "ENDING 1: Burnt Beyond Recognition"
			cake_illustration.texture = load("res://assets/art/cake_burnt.png")
			grandma_comment_label.text = "\"I asked for baked, not cremated, darling!\""
			AudioManager.play_bgm(preload("res://assets/sounds/result_bgm_2.mp3"))
		"perfect":
			title_label.text = "ENDING 2: Too Perfect"
			cake_illustration.texture = load("res://assets/art/cake_perfect.png")
			grandma_comment_label.text = "\"This is way too precise... Where is the love and chaos?!\""
			AudioManager.play_bgm(preload("res://assets/sounds/result_bgm_1.mp3"))
		"favorite":
			title_label.text = "ENDING 3: Grandma's Favorite"
			cake_illustration.texture = load("res://assets/art/cake_favorite.png")
			grandma_comment_label.text = "\"Messy, chaotic, and completely wrong... Just how I like it!\""
			AudioManager.play_bgm(preload("res://assets/sounds/result_bgm_2.mp3"))
		"soup":
			title_label.text = "ENDING 4: Soup Cake"
			cake_illustration.texture = load("res://assets/art/cake_soup.png")
			grandma_comment_label.text = "\"Wait What?\""
			AudioManager.play_bgm(preload("res://assets/sounds/result_bgm_2.mp3"))

func _on_try_again_pressed() -> void:
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/kitchen.tscn")
