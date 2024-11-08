extends Node  # Наследуем класс Node для создания узла в сцене

@onready var pause_menu: Control = get_node_or_null("../CanvasLayer/PauseMenu")  # Ссылка на меню паузы

var game_paused: bool = false  # Флаг для отслеживания состояния паузы

# Вызывается, когда узел впервые входит в дерево сцен.
func _ready() -> void:
	# Проверяем, найден ли pause_menu
	if pause_menu == null:
		print("Ошибка: Узел PauseMenu не найден.")  # Выводим ошибку, если меню не найдено
	else:
		pause_menu.hide()  # Скрываем меню при старте

# Вызывается каждый кадр. 'delta' - это время, прошедшее с предыдущего кадра.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):  # Проверяем, нажата ли кнопка для отмены (например, 'Esc')
		game_paused = !game_paused  # Переключаем состояние паузы

	if game_paused:  # Если игра на паузе
		get_tree().paused = true  # Приостанавливаем дерево сцен
		if pause_menu:  # Проверяем, существует ли меню паузы
			pause_menu.show()  # Показываем меню, если оно существует
	else:  # Если игра не на паузе
		get_tree().paused = false  # Возобновляем работу дерева сцен
		if pause_menu:  # Проверяем, существует ли меню паузы
			pause_menu.hide()  # Скрываем меню, если оно существует

# Вызывается при нажатии кнопки "Продолжить"
func _on_resume_pressed() -> void:
	game_paused = !game_paused  # Переключаем состояние паузы (возвращаемся в игру)

# Вызывается при нажатии кнопки "Выход"
func _on_quit_pressed() -> void:
	get_tree().paused = false  # Снимаем паузу с игры
	get_tree().quit(0)  # Выходим из игры

# Обработчики событий при входе/выходе из дверей (например, для смены сцены)
func _on_door_city_body_entered(body: Node2D) -> void:
	pass  # Замените на тело функции, если требуется логика при входе в дверь города

func _on_door_city_body_exited(body: Node2D) -> void:
	pass  # Замените на тело функции, если требуется логика при выходе из двери города

func _on_door_level_1_body_entered(body: Node2D) -> void:
	pass  # Замените на тело функции, если требуется логика при входе в дверь уровня 1

func _on_door_level_1_body_exited(body: Node2D) -> void:
	pass  # Замените на тело функции, если требуется логика при выходе из двери уровня 1
