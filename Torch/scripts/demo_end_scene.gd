extends Control  # Наследуем класс Control для создания интерфейсного элемента

@onready var endAudio = $endAudio  # Получаем ссылку на аудио, которое будет воспроизводиться в конце
@onready var buttonAudio = $buttonAudio  # Получаем ссылку на аудио кнопки

func _ready() -> void:
	visible = false  # Скрываем элемент управления при готовности

func _process(delta: float) -> void:
	# Если элемент управления видим, продолжаем выполнение
	if visible == true:
		get_tree().paused = false  # Разрешаем продолжение игры
		endAudio.play()  # Воспроизводим аудио окончания

func _on_quit_btn_pressed() -> void:
	# Обработчик нажатия кнопки выхода
	buttonAudio.play()  # Воспроизводим звук нажатия кнопки
	await buttonAudio.finished  # Ждем завершения звука
	get_tree().paused = true  # Приостанавливаем игру
	get_tree().change_scene_to_file("res://scenes/menu.tscn")  # Переходим к главному меню

	
