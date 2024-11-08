extends Control  # Наследуем класс Control для создания пользовательского интерфейса

@onready var buttonAudio = $buttonAudio  # Получаем ссылку на аудио кнопки

var restart_scene = load("res://UI/restart_menu.tscn").instantiate()  # Загружаем сцену меню перезапуска

var _is_paused : bool = false:  # Переменная для отслеживания состояния паузы
	set = set_paused  # Устанавливаем сеттер для переменной _is_paused
	
# Метод для обработки неразрешенных входных событий
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):  # Проверяем, была ли нажата кнопка отмены
		buttonAudio.play()  # Проигрываем звук кнопки
		await buttonAudio.finished  # Ждем завершения звука
		_is_paused = !_is_paused  # Переключаем состояние паузы
	
# Метод для установки состояния паузы
func set_paused(value: bool) -> void:
	_is_paused = value  # Устанавливаем новое значение для _is_paused
	get_tree().paused = _is_paused  # Устанавливаем состояние паузы в дереве сцен
	visible = _is_paused  # Делим меню видимым или невидимым в зависимости от состояния паузы

# Метод, вызываемый при нажатии кнопки "Продолжить"
func _on_resume_btn_pressed() -> void:
	buttonAudio.play()  # Проигрываем звук кнопки
	await buttonAudio.finished  # Ждем завершения звука
	_is_paused = false  # Снимаем паузу

# Метод, вызываемый при нажатии кнопки "Перезапустить"
func _on_restart_btn_pressed() -> void:
	buttonAudio.play()  # Проигрываем звук кнопки
	await buttonAudio.finished  # Ждем завершения звука
	_is_paused = true  # Устанавливаем состояние паузы на true
	var restart_scene = load("res://UI/restart_menu.tscn").instantiate()  # Загружаем сцену меню перезапуска
	add_child(restart_scene)  # Добавляем меню перезапуска в дерево сцен
	
# Метод, вызываемый при нажатии кнопки "Выйти"
func _on_quit_btn_pressed() -> void:
	buttonAudio.play()  # Проигрываем звук кнопки
	await buttonAudio.finished  # Ждем завершения звука
	hide()  # Скрываем текущее меню
	get_tree().change_scene_to_file("res://scenes/menu.tscn")  # Переключаемся на главное меню
