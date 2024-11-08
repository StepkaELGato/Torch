extends Control  # Наследуем класс Control для управления интерфейсом диалога

@onready var dialogWindow = $".."  # Ссылка на окно диалога
@onready var skipPanel = $Panel/Panel2  # Ссылка на панель пропуска диалога
@onready var labelName = $Panel/name  # Ссылка на Label для отображения имени говорящего
@onready var labelWords = $Panel/words  # Ссылка на Label для отображения текста диалога
@onready var timer = $Timer  # Ссылка на таймер для управления временем

var can_press = true  # Флаг для контроля ввода

# Эта функция вызывается каждый кадр. 'delta' — время, прошедшее с предыдущего кадра.
func _process(delta: float) -> void:
	# Проверяем, видно ли окно диалога и разрешен ли ввод
	if dialogWindow.visible == true && can_press:  
		get_tree().paused = true  # Приостанавливаем игровое дерево для блокировки ввода
		labelName.text = "Тео Снорбест"  # Устанавливаем имя говорящего
		labelWords.text = "Как я помню, нужно пройти по этой улице и подняться наверх, чтобы добраться до офиса этой компании"  # Устанавливаем текст диалога
		can_press = false  # Блокируем возможность повторного ввода
		timer.start()  # Запускаем таймер для управления временем диалога

	# Проверяем, истек ли таймер и нажата ли кнопка атаки
	if timer.timeout && Input.is_action_just_pressed("attack"):  # 'attack' — это имя действия, можно изменить
		dialogWindow.visible = false  # Скрываем окно диалога
		get_tree().paused = false  # Возвращаем управление дереву, продолжая игру

# Функция, вызываемая по истечении времени таймера
func _on_timer_timeout() -> void:
	skipPanel.visible = true  # Показываем панель пропуска диалога
