# Скрипт, который управляет уровнем (например, в MainScene)
extends Node  # Наследуем класс Node для создания узла в сцене

@onready var levelAudio = $levelAudio  # Получаем ссылку на узел аудио уровня

@onready var door_level_2: Area2D = $Door_to_Level2/doorLevel2  # Получаем ссылку на Area2D двери для перехода на уровень 2

@onready var scene = preload("res://scenes/menu.tscn").instantiate()  # Загружаем и инстанцируем сцену меню

# Вызывается, когда узел впервые входит в дерево сцен.
func _ready() -> void:
	levelAudio.play()  # Запускаем аудио уровня при старте
	KillStates.reset_kills()  # Сбрасываем количество убийств при запуске новой сцены
	# Передаем узел двери в KillStates для управления состоянием перехода
	if KillStates:
		KillStates.set_door(door_level_2)  # Передаем узел двери в KillStates
	else:
		print("Ошибка: KillStates не найден")  # Выводим ошибку, если KillStates не найден

# Вызывается каждый кадр, 'delta' — это прошедшее время с предыдущего кадра.
func _process(delta: float) -> void:
	if get_tree().current_scene == scene:  # Проверяем, является ли текущая сцена меню
		print("MENU")  # Выводим сообщение о том, что находимся в меню
		queue_free()  # Удаляем текущую сцену из дерева сцен

# Вызывается, когда аудио уровня заканчивается
func _on_level_audio_finished() -> void:
	levelAudio.play()  # Снова запускаем аудио уровня, если оно завершилось

	
