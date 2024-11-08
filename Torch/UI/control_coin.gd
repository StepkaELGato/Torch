extends Control  # Наследуем класс Control для создания пользовательского интерфейса

@onready var coins_label: Label = $CoinsLable  # Получаем ссылку на Label для отображения количества монет

func _ready() -> void:
	# Этот метод вызывается, когда узел входит в дерево сцен
	# Передаем Label в глобальный скрипт для отображения монет
	if CoinStates and coins_label:  # Проверяем, существует ли CoinStates и Label для монет
		CoinStates.set_coins_label(coins_label)  # Устанавливаем Label для отображения количества монет в глобальном скрипте
	else:
		print("Ошибка: CoinStates или CoinsLabel не найдены")  # Сообщаем об ошибке, если что-то не так

# Пример вызова функции при сборе монеты
func on_coin_collected() -> void:
	CoinStates.add_coin(1)  # Увеличиваем количество монет на 1 в глобальном скрипте
