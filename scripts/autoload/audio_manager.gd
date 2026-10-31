extends Node

var bgm_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer

var target_bgm_pitch: float = 1.0
var pitch_change_speed: float = 2.0

func _ready() -> void:
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "BGM"
	add_child(bgm_player)
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "SFX"
	add_child(sfx_player)

func _process(delta: float) -> void:
	if bgm_player.playing:
		bgm_player.pitch_scale = move_toward(bgm_player.pitch_scale, target_bgm_pitch, pitch_change_speed * delta)

func play_bgm(stream: AudioStream) -> void:
	if bgm_player.stream != stream:
		bgm_player.stream = stream
		bgm_player.pitch_scale = 1.0
		target_bgm_pitch = 1.0
		bgm_player.play()

func stop_bgm() -> void:
	bgm_player.stop()

func set_bgm_panic_mode(is_panic: bool) -> void:
	if is_panic:
		target_bgm_pitch = 1.15 
	else:
		target_bgm_pitch = 1.0

func play_sfx(stream: AudioStream, pitch_randomness: float = 0.1) -> void:
	if stream:
		var temp_sfx = AudioStreamPlayer.new()
		add_child(temp_sfx)
		temp_sfx.stream = stream
		temp_sfx.pitch_scale = randf_range(1.0 - pitch_randomness, 1.0 + pitch_randomness)
		temp_sfx.play()
		temp_sfx.finished.connect(temp_sfx.queue_free)
