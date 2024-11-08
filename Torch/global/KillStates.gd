extends Node  # Наследуем класс Node для создания логики игры

@onready var door_area: Area2D = get_node_or_null("../Door_to_Level2/doorLevel2")  # Проверь путь к двери
@onready var door_level_3: Area2D = get_node_or_null("../Door_to_Level3/doorLevel3")  # Путь к двери на уровень 3
@onready var door_level_4: Area2D = get_node_or_null("../Door_to_Level4/doorLevel4")  # Путь к двери на уровень 4

# Переменная для хранения количества убийств
var kills: int = 0  # Инициализируем счетчик убийств

# Ссылка на Label для отображения количества убийств
var kills_label: Label = null  # Сюда будет передаваться Label из сцены

# Вызывается, когда узел впервые входит в дерево сцен
func _ready() -> void:
	if is_instance_valid(door_area):  # Проверяем, существует ли дверь
		door_area.activate_door()  # Активация двери, если это нужно
	else:
		print("Ошибка: Дверь не найдена.")  # Сообщение об ошибке, если дверь не найдена

# Метод для установки ссылки на Label из сцены
func set_kills_label(label: Label) -> void:
	kills_label = label  # Получаем Label из сцены
	print("Label передан в KillStates:", kills_label)  # Подтверждение передачи Label

# Функция для увеличения количества убийств
func enemy_killed() -> void:
	kills += 1  # Увеличиваем счетчик убийств на 1
	print("Убийств: ", kills)  # Выводим количество убийств в консоль

	# Обновляем текст в Label, если он установлен
	if kills_label:
		kills_label.text = str(kills)  # Обновляем текст Label с количеством убийств
	else:
		print("Ошибка: Label не установлен")  # Сообщение об ошибке, если Label не установлен

	# Если убито 4 врага, активируем дверь
	if kills >= 4:
		print("Уровень пройден!")  # Уведомление о пройденном уровне
		if door_area != null:  # Проверяем, существует ли дверь
			door_area.activate_door()  # Активируем дверь
			print("Дверь активирована")  # Сообщение об активации двери
		else:
			print("Ошибка: Дверь не установлена")  # Сообщение об ошибке, если дверь не установлена
			
	if kills >= 6:  # Если убито 6 врагов
		print("Второй уровень зачищен")  # Сообщение о зачистке уровня
		if door_level_3 != null:  # Проверяем, существует ли дверь уровня 3
			door_level_3.activate_door()  # Активируем дверь уровня 3
			print("Дверь Уровня 2 активирована")  # Сообщение об активации двери уровня 3
		else:
			print("Ошибка: Дверь Уровня 2 не установлена")  # Сообщение об ошибке

	if kills >= 7:  # Если убито 7 врагов
		print("Второй уровень зачищен")  # Сообщение о зачистке уровня
		if door_level_4 != null:  # Проверяем, существует ли дверь уровня 4
			door_level_4.activate_door()  # Активируем дверь уровня 4
			print("Дверь Уровня 3 активирована")  # Сообщение об активации двери уровня 4
		else:
			print("Ошибка: Дверь Уровня 3 не установлена")  # Сообщение об ошибке

# Функция для перехода на следующую сцену
func teleport_to_next_scene() -> void:
	reset_kills()  # Сбрасываем количество убийств перед переходом на новый уровень
	print("Убийства сброшены. Переход к следующей сцене.")  # Сообщение о сбросе убийств
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")  # Замените путь на нужный вам

# Функция для сброса количества убийств
func reset_kills() -> void:
	kills = 0  # Сбрасываем счетчик убийств
	if kills_label:
		kills_label.text = str(kills)  # Обновляем текст Label с новым количеством убийств

# Метод для обновления ссылки на дверь
func set_door(door_node: Area2D) -> void:
	door_area = door_node  # Обновляем ссылку на дверь
