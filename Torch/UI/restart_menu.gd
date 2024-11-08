extends Control  # Наследуем класс Control для создания пользовательского интерфейса

@onready var buttonAudio = $buttonAudio  # Получаем ссылку на аудио кнопки

# Вызывается, когда узел впервые входит в дерево сцен
func _ready() -> void:
	get_tree().paused = true  # Ставим игру на паузу

# Вызывается каждый кадр. 'delta' - это время, прошедшее с предыдущего кадра
func _process(delta: float) -> void:
	pass  # Здесь нет действий каждый кадр

# Метод, вызываемый при нажатии кнопки "Перезапустить уровень"
func _on_restart_level_btn_pressed() -> void:
	buttonAudio.play()  # Проигрываем звук кнопки
	await buttonAudio.finished  # Ждем завершения звука
	restart_scene()  # Перезапускаем уровень

# Метод для перезапуска текущей сцены
func restart_scene():
	var current_scene = get_tree().current_scene  # Получаем текущую сцену
	get_tree().reload_current_scene()  # Перезагружаем текущую сцену

# Метод для обработки входных событий
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # Проверяем, была ли нажата кнопка отмены
		buttonAudio.play()  # Проигрываем звук кнопки
		await buttonAudio.finished  # Ждем завершения звука
		queue_free()  # Удаляем этот узел из дерева сцен

# Метод, вызываемый при нажатии кнопки "Перезапустить игру"
func _on_restart_game_btn_pressed() -> void:
	buttonAudio.play()  # Проигрываем звук кнопки
	await buttonAudio.finished  # Ждем завершения звука
	Global.set_start_scene(false)  # Устанавливаем начальную сцену в глобальном скрипте
	get_tree().change_scene_to_file("res://scenes/teo_house.tscn")  # Переключаемся на сцену "teo_house"
