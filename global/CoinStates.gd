extends Node  # Наследуем класс Node для управления монетами

var coins: int = 0  # Текущее количество монет
var coins_label: Label = null  # Ссылка на Label для отображения количества монет

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass  # Функция, вызываемая при готовности узла (можно добавить инициализацию)

# Функция, вызываемая при сборе монеты
func _on_coin_collected() -> void:
	add_coin(1)  # Увеличиваем количество монет на 1

# Устанавливает ссылку на Label, который будет использоваться для отображения количества монет
func set_coins_label(label: Label) -> void:
	coins_label = label  # Сохраняем ссылку на Label для обновления текста

# Добавляет указанное количество монет (по умолчанию 1)
func add_coin(amount: int = 1) -> void:
	coins += amount  # Увеличиваем текущее количество монет
	update_coins_label()  # Обновляем отображение количества монет

# Обновляет текст в Label, отображающем количество монет
func update_coins_label() -> void:
	if coins_label:  # Проверяем, установлен ли Label
		coins_label.text = str(coins)  # Обновляем текст в Label
	else:
		print("Ошибка: Label для монет не установлен")  # Сообщение об ошибке, если Label не установлен
