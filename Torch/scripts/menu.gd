extends Node  # Наследуем класс Node для создания узла в сцене

@onready var menuAudio = $menuAudio  # Ссылка на узел аудио для фона меню
@onready var buttonAudio = $buttonAudio  # Ссылка на узел аудио для звуков кнопок

# Вызывается, когда узел впервые входит в дерево сцен.
func _ready() -> void:
	get_tree().paused = false  # Снимаем паузу с дерева сцен
	menuAudio.play()  # Запускаем фоновую музыку меню

# Вызывается каждый кадр. 'delta' - это время, прошедшее с предыдущего кадра.
func _process(delta: float) -> void:
	pass  # Здесь можно добавить логику, которая будет выполняться каждый кадр

# Вызывается при нажатии кнопки "Начать"
func _on_start_pressed() -> void:
	buttonAudio.play()  # Проигрываем звук нажатия кнопки
	await buttonAudio.finished  # Ждем окончания звука
	Global.set_start_scene(true)  # Устанавливаем флаг для начала сцены
	SceneTransitionManager.load_scene("res://cutscene/start_cutscene.tscn")  # Загружаем сцену стартовой кат-сцены
	menuAudio.stop()  # Останавливаем фоновую музыку меню

# Вызывается при нажатии кнопки "Создатели"
func _on_creaters_pressed() -> void:
	buttonAudio.play()  # Проигрываем звук нажатия кнопки
	await buttonAudio.finished  # Ждем окончания звука
	get_tree().change_scene_to_file("res://scenes/creaters.tscn")  # Переключаемся на сцену создателей
	menuAudio.stop()  # Останавливаем фоновую музыку меню

# Вызывается при нажатии кнопки "Выход"
func _on_quit_pressed() -> void:
	buttonAudio.play()  # Проигрываем звук нажатия кнопки
	await buttonAudio.finished  # Ждем окончания звука
	get_tree().quit(0)  # Выходим из игры
	menuAudio.stop()  # Останавливаем фоновую музыку меню

# Вызывается, когда аудио меню завершает воспроизведение
func _on_menu_audio_finished() -> void:
	menuAudio.play()  # Запускаем воспроизведение аудио меню заново
