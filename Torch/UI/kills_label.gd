extends Node  # Наследуем класс Node для создания узла в сцене

@onready var kills_label: Label = $KillsLabel  # Получаем ссылку на Label в сцене, который будет отображать количество убийств

func _ready() -> void:
	# Проверяем, существуют ли глобальный скрипт KillStates и Label
	if KillStates and kills_label:
		KillStates.set_kills_label(kills_label)  # Передаем Label в KillStates для отображения количества убийств
	else:
		print("Ошибка: KillStates или KillsLabel не найдены")  # Выводим сообщение об ошибке, если что-то не найдено
		
	# Дополнительные проверки на наличие KillStates и kills_label
	if !KillStates:
		print("Ошибка: глобальный скрипт KillStates не найден")  # Сообщаем, если KillStates отсутствует
	if !kills_label:
		print("Ошибка: KillsLabel не найден")  # Сообщаем, если KillsLabel отсутствует

# Пример вызова функции enemy_killed(), когда враг убит
func on_enemy_defeated() -> void:
	KillStates.enemy_killed()  # Увеличиваем счётчик убийств в KillStates
