extends Node  # Наследуем класс Node для создания базового узла

@onready var menuAudio = $menuAudio  # Получаем ссылку на аудио меню
@onready var buttonAudio = $buttonAudio  # Получаем ссылку на аудио кнопки

# Вызывается при первом входе узла в дерево сцен.
func _ready() -> void:
	menuAudio.play()  # Воспроизводим аудио меню при инициализации

# Вызывается каждый кадр. 'delta' - время, прошедшее с предыдущего кадра.
func _process(delta: float) -> void:
	pass  # Здесь можно добавить код, который будет выполняться каждый кадр, если это необходимо

func _on_back_button_pressed() -> void:
	# Обработчик нажатия кнопки "Назад"
	buttonAudio.play()  # Воспроизводим звук нажатия кнопки
	await buttonAudio.finished  # Ждем завершения звука
	get_tree().change_scene_to_file("res://scenes/menu.tscn")  # Переходим к главному меню
	menuAudio.stop()  # Останавливаем воспроизведение аудио меню

func _on_menu_audio_finished() -> void:
	# Обработчик завершения воспроизведения аудио меню
	menuAudio.play()  # Снова воспроизводим аудио меню
