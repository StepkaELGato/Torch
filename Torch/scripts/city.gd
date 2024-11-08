extends Node

@onready var streetAudio = $streetAudio
@onready var dialogWindow = $Dialog
@onready var timer = $Dialog/DialogCity/Timer

# Получаем узел PauseMenu по абсолютному пути
@onready var pause_menu: Control = get_node_or_null("CanvasLayer/PauseMenu")
#var game_paused: bool = false

func _ready() -> void:
	timer.start()
	await timer.timeout
	dialogWindow.visible = true
	streetAudio.play()
	# Проверяем, найден ли pause_menu
	if pause_menu == null:
		print("Ошибка: Узел PauseMenu не найден. Проверьте путь!")
	else:
		pause_menu.hide()  # Скрываем меню при старте

func _process(delta: float) -> void:
	pass

func _on_street_audio_finished() -> void:
	streetAudio.play()
