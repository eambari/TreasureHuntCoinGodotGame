extends Node

@export var game_time := 120  # 2 minutes
@export var total_treasures := 40

@onready var timer_label = $TimerLabel
@onready var game_over_panel = $GameOverPanel
@onready var result_label = $GameOverPanel/ResultLabel
@onready var timer = $GameTimer
@onready var player = $"../../SophieCharacterController"
@onready var coin_label = $"../../Level/CoinLabel"

@onready var background_music: AudioStreamPlayer = $BackgroundMusic
@onready var coin_sound: AudioStreamPlayer = $CoinSound
@onready var win_sound: AudioStreamPlayer = $WinSound
@onready var lose_sound: AudioStreamPlayer = $LoseSound

var time_remaining: float
var collected_treasures := 0

func _ready() -> void:
	game_over_panel.hide()
	time_remaining = game_time
	timer.connect("timeout", _on_game_timer_timeout)
	var restart_button = $GameOverPanel/RestartButton
	restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
	timer.wait_time = game_time
	timer.start()
	update_timer_display()
	background_music.play()

func _process(_delta: float) -> void:
	time_remaining = timer.time_left
	update_timer_display()

func update_timer_display() -> void:
	var minutes = floor(time_remaining / 60)
	var seconds = int(time_remaining) % 60
	timer_label.text = "Time Left: " + "%02d:%02d" % [minutes, seconds]

func _on_game_timer_timeout() -> void:
	end_game(false)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("coin"):
		collected_treasures += 1
		coin_label.text = "Coin Count: " + str(collected_treasures) + "/" + str(total_treasures)
		coin_sound.play()
		area.queue_free()
	if collected_treasures >= total_treasures:
		end_game(true)

func end_game(victory: bool) -> void:
	timer.stop()
	game_over_panel.show()
	result_label.text = "You Won!" if victory else "You Lost!"
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	if victory:
		win_sound.play()
	else:
		lose_sound.play()
	var tween = create_tween()
	tween.tween_property(background_music, "volume_db", -80.0, 1.0)

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().reload_current_scene()
