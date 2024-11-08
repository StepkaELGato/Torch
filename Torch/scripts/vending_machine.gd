extends Area2D  # Наследуем класс Area2D для создания зоны взаимодействия

var player_in_area: bool = false  # Флаг для отслеживания, находится ли игрок в области
var can_interact = false  # Флаг для проверки возможности взаимодействия с объектом

# Получаем ссылку на диалог подтверждения
@export var player: Node2D  # Переменная для хранения ссылки на игрока

@onready var heal_menu2: Control = get_node_or_null("../../HealMenu/heal_menu2")  # Получаем ссылку на меню лечения

# Метод, вызываемый при первой загрузке сцены
func _ready() -> void:
	var can_interact = false  # Инициализация флага взаимодействия
	for child in get_children():
		print(child)  # Выводим в консоль всех дочерних узлов
	# Скрываем меню лечения по умолчанию
	if heal_menu2:
		heal_menu2.visible = false  # Меню лечения изначально невидимо
	print(heal_menu2)  # Выводим ссылку на меню в консоль

# Когда игрок входит в зону
func _on_body_entered(body: Node) -> void:
	player_in_area = true  # Устанавливаем флаг, что игрок в зоне
	print("Игрок в зоне взаимодействия с предметом")  # Выводим сообщение в консоль
	if body is CharacterBody2D:  # Проверяем, что объект — это игрок
		can_interact = true  # Разрешаем взаимодействие

# Когда игрок выходит из зоны
func _on_body_exited(body: Node) -> void:
	if body is CharacterBody2D:  # Проверяем, что объект — это игрок
		player_in_area = false  # Устанавливаем флаг, что игрок покинул зону
		print("Игрок покинул зону взаимодействия с предметом")  # Выводим сообщение в консоль
		can_interact = false  # Запрещаем взаимодействие
		if heal_menu2:
			heal_menu2.visible = false  # Скрываем меню лечения
			can_interact = false  # Обнуляем флаг взаимодействия

# Проверяем взаимодействие при нажатии клавиши
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interaction") and can_interact == true:  # Клавиша 'E' для взаимодействия
		heal_menu2.visible = true  # Показываем меню лечения

# Метод для взаимодействия с предметом
func interact_with_item() -> void:
	print("Игрок взаимодействует с предметом!")  # Сообщение о взаимодействии
	open_heal_dialog()  # Открываем диалог лечения

# Метод для открытия окна лечения
func open_heal_dialog() -> void:
	pass  # Временно не реализован

# Метод для лечения игрока
func heal_player() -> void:
	player.currentHealth += 1  # Восстанавливаем 1 очко здоровья
	print("Игрок похилен!")  # Сообщение о лечении
	close_heal_dialog()  # Закрываем окно после лечения

# Метод для закрытия окна без лечения
func close_heal_dialog() -> void:
	print("Окно закрыто.")  # Сообщение о закрытии окна
