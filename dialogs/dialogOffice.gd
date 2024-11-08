extends Control  # Наследуем класс Control для управления интерфейсом диалога

@onready var animationAlarm = $"../alarmAnimation"  # Ссылка на анимацию тревоги
@onready var dialogWindow = $".."  # Ссылка на окно диалога
@onready var skipPanel = $Panel/Panel2  # Ссылка на панель пропуска диалога
@onready var labelName = $Panel/name  # Ссылка на Label для отображения имени говорящего
@onready var labelWords = $Panel/words  # Ссылка на Label для отображения текста диалога
@onready var timer = $Timer  # Ссылка на таймер для управления временем
@onready var animationWay = $"../../DoorLevel1/AnimationWay"  # Ссылка на анимацию двери

var startCount = 0  # Счетчик для отслеживания начала диалога
var talkCount = 0  # Счетчик для отслеживания текущего диалога

var can_press = true  # Флаг для контроля ввода
var greetings = "Добропожаловать в Уайт! Проходите к администратору на ресепшн."  # Приветственное сообщение
var greetingsName = "Aдминистратор Сью"  # Имя говорящего в приветствии
var talk = [  # Массив с текстами диалога
	"Добропожаловать в Уайт! Я администратор Сью. Подскажите цель вашего визита?",
	"Здравствуйте. Я пришёл на собеседование. Увидел в объявлении, что оно проходит сегодня.",
	"Да, это так. Скажите свою фамилию и имя, пожайлуста.",
	"Тео Снорбест.",
	"Отлично. Вы можете пройти и...",
	"Что случилось?! Почему началась тревога?!",
	"О нет! Босс в опасности! На здание напала соседняя организация.",
	"В объявлении было указано, что нам нужны охранники. Помогите Боссу сейчас и я уверена, что он сразу примет вас на работу!",
	"Ох... Не на это я расчитывал. Ладно, я помогу вам. Надеюсь ваш Босс и правда не останется в долгу.",
	"Отлично! Около нас находится дверь, которая ведёт к лестнице. Поспешите наверх! Босс на самом последнем этаже."
]
var talkName = [  # Массив с именами говорящих
	"Администратор Сью",
	"Тео Снорбест",
	"Администратор Сью",
	"Тео Снорбест",
	"Администратор Сью",
	"Администратор Сью",
	"Администратор Сью",
	"Администратор Сью",
	"Тео Снорбест",
	"Администратор Сью",
]

var labelCount = 0  # Счетчик для отслеживания текущего текста диалога

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skipPanel.visible = false  # Скрываем панель пропуска в начале
	labelName.text = greetingsName  # Устанавливаем имя говорящего
	labelWords.text = greetings  # Устанавливаем приветственное сообщение
	can_press = false  # Блокируем возможность ввода в начале
	timer.start()  # Запускаем таймер для управления задержкой

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dialogWindow.visible == true:  # Если окно диалога видно
		get_tree().paused = true  # Приостанавливаем дерево для блокировки ввода
		if can_press && Input.is_action_just_pressed("attack"):  # Проверяем, можно ли нажимать и нажата ли кнопка
			if startCount == 0:  # Если это начало диалога
				dialogWindow.visible = false  # Скрываем окно диалога
				get_tree().paused = false  # Возвращаем управление дереву
				startCount += 1  # Увеличиваем счетчик начала
			else:
				skipPanel.visible = false  # Скрываем панель пропуска
				update_label()  # Обновляем текст диалога
				can_press = false  # Блокируем дальнейшие нажатия
				timer.start()  # Запускаем таймер
		
		if talkCount == 0 && startCount == 1:  # Если это первая часть диалога
			skipPanel.visible = false  # Скрываем панель пропуска
			can_press = false  # Блокируем ввод
			update_label()  # Обновляем текст диалога
			timer.start()  # Запускаем таймер
			

# Функция, вызываемая по истечении времени таймера
func _on_timer_timeout() -> void:
	skipPanel.visible = true  # Показываем панель пропуска
	can_press = true  # Разрешаем ввод

# Функция, вызываемая при входе в область диалога
func _on_talk_area_area_entered(area: Area2D) -> void:
	if startCount == 1:  # Если диалог уже начался
		dialogWindow.visible = true  # Показываем окно диалога
		startCount += 1  # Увеличиваем счетчик начала

# Функция для обновления текста в Label
func update_label() -> void:
	if labelCount < 10:  # Если не достигли конца диалога
		labelName.text = talkName[labelCount]  # Устанавливаем имя говорящего
		labelWords.text = talk[labelCount]  # Устанавливаем текст диалога
		labelCount += 1  # Увеличиваем счетчик текста
		if labelCount == 5:  # Если это пятый текст
			animationAlarm.play("alarm")  # Запускаем анимацию тревоги
	else:
		animationAlarm.play("RESET")  # Сбрасываем анимацию тревоги
		animationWay.play("way")  # Запускаем анимацию пути
		# Смена сцены после последнего текста
		dialogWindow.visible = false  # Скрываем окно диалога
		get_tree().paused = false  # Возвращаем управление дереву
		talkCount += 1  # Увеличиваем счетчик диалога
