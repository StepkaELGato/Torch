extends Node2D  # Наследуем класс Node2D для создания интерфейса

@onready var label = $Panel/words  # Получаем ссылку на Label для отображения текста
@onready var textureRect = $TextureRect  # Получаем ссылку на TextureRect для отображения изображений
@onready var timer = $Timer  # Получаем ссылку на Timer для управления временем
@onready var skipPanel = $Panel2  # Получаем ссылку на панель для пропуска

# Список слов, которые будут отображаться
var words = [
	"Ужасная скука…",
	"Каждый день похож на другой…",
	"Я уже и не помню, когда занимался чем-то, кроме работы в офисе.",
	"Будто я проживаю день сурка. Будто весь город его проживает.",
	"Я начинаю терять смысл во всём этом…",
	"Хочется чего-то нового… Интересного… Чего-то, что сможет меня оживить.",
	"!!!",
	"Точно, я и забыл про него!",
	"Это объявление о приеме на работу в самую престижную компанию в городе!",
	"На должность охранника? Ну и ладно. Это всё равно веселее, чем просиживать штаны в офисе.",
	"Хоть где-то пригодится диплом из детской школы боевых искусств. Ха-ха."
]

# Список текстур, которые будут отображаться
var textures = [
	preload("res://cutscene/cutscene1_1.jpg"),
	preload("res://cutscene/cutscene1_2.jpg"),
	preload("res://cutscene/cutscene1_3.jpg"),
]

var labelCount = 0  # Счетчик для отслеживания текущего текста
var imageCount = 0  # Счетчик для отслеживания текущего изображения
var can_press = true  # Флаг для контроля ввода

# Устанавливаем начальный текст и изображение
func _ready() -> void:
	label.text = words[0]  # Устанавливаем первый текст в Label
	textureRect.texture = textures[0]  # Устанавливаем первое изображение
	can_press = false  # Запрещаем ввод
	timer.start()  # Запускаем таймер для управления временем

# Обрабатываем нажатие кнопки и переключение текста/изображений
func _process(delta: float) -> void:
	if can_press && Input.is_action_just_pressed("attack"):  # Проверяем, была ли нажата кнопка 'attack'
		skipPanel.visible = false  # Скрываем панель пропуска
		update_label_and_image()  # Обновляем текст и изображение
		can_press = false  # Блокируем дальнейшие нажатия
		timer.start()  # Запускаем таймер

# Обновляем текст и изображение
func update_label_and_image() -> void:
	if labelCount < words.size() - 1:  # Проверяем, не достигли ли мы конца списка слов
		labelCount += 1  # Увеличиваем счетчик текста
		label.text = words[labelCount]  # Обновляем текст в Label
		# Обновляем изображение, если текст на определённом шаге
		if labelCount == 3 or labelCount == 7:  # Проверяем, нужно ли обновить изображение
			if imageCount < textures.size() - 1:  # Проверяем, не достигли ли мы конца списка текстур
				imageCount += 1  # Увеличиваем счетчик изображений
				textureRect.texture = textures[imageCount]  # Обновляем изображение
	else:
		# Смена сцены после последнего текста
		SceneTransitionManager.load_scene("res://scenes/teo_house.tscn")  # Загружаем следующую сцену

# Метод, вызываемый при завершении таймера
func _on_timer_timeout() -> void:
	skipPanel.visible = true  # Показываем панель пропуска
	can_press = true  # Разрешаем ввод снова
