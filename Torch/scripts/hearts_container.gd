extends HBoxContainer  # Наследуем от HBoxContainer для размещения сердец в горизонтальном контейнере

# Заранее загружаем сцену для GUI-сердца, чтобы создать визуальные индикаторы здоровья
@onready var HeartGuiClass = preload("res://scenes/heart_gui.tscn")

# Вызывается, когда узел добавляется в сцену (инициализация узла)
func _ready() -> void:
	pass  # Тело функции пока пустое

# Вызывается каждый кадр. 'delta' - время, прошедшее с последнего кадра
func _process(delta: float) -> void:
	pass  # Тело функции пока пустое

# Устанавливает максимальное количество сердец (индикаторов здоровья) на основе максимального здоровья
func setMaxHearts(max: int):
	for i in range(max):  # Создаем и добавляем сердца в контейнер на основе заданного количества
		var heart = HeartGuiClass.instantiate()  # Создаем экземпляр GUI-сердца
		add_child(heart)  # Добавляем созданное сердце в контейнер

# Обновляет отображение здоровья, показывая активные и неактивные сердца
func updateHearts(currentHealth: int):
	var hearts = get_children()  # Получаем список всех сердец в контейнере
	
	# Устанавливаем активное состояние (показывает заполненные сердца) для текущего количества здоровья
	for i in range(currentHealth):
		hearts[i].update(true)  # Включаем сердце, если оно входит в количество текущего здоровья
		
	# Отключаем оставшиеся сердца, показывая пустые индикаторы для отсутствующего здоровья
	for i in range(currentHealth, hearts.size()):
		hearts[i].update(false)  # Отключаем сердце, если оно превышает текущее здоровье
