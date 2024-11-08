extends Area2D  # Наследуем класс Area2D для определения области взаимодействия

@export var next_scene = "res://scenes/teo_house.tscn"  # Путь к следующей сцене
@export var next_spawn_marker_name = "teo_house_marker"  # Имя маркера спавна для следующей сцены

@onready var streetAudio = $"../../streetAudio"  # Ссылка на аудио улицы
@onready var doorAudio = $"../../doorAudio"  # Ссылка на аудио двери

var entered = false  # Флаг для отслеживания, находится ли игрок в области

# Метод, вызываемый при первой загрузке сцены
func _ready() -> void:
	entered = false  # Сбрасываем флаг при загрузке

# Обработчик события, когда другой объект входит в область
func _on_body_entered(body) -> void:
	entered = true  # Устанавливаем флаг, когда игрок входит в область

# Обработчик события, когда другой объект выходит из области
func _on_body_exited(body) -> void:
	entered = false  # Сбрасываем флаг, когда игрок выходит из области

# Метод, который вызывается каждый кадр (не используется в данный момент)
func _process(delta: float) -> void:
	pass  # Здесь можно добавить код, который нужно выполнять каждый кадр

# Метод для обработки пользовательского ввода
func _input(event: InputEvent) -> void:
	# Проверяем, нажата ли клавиша взаимодействия
	if Input.is_action_pressed("interaction"):
		# Проверяем, есть ли объекты в области взаимодействия
		if get_overlapping_bodies().size() > 0:
			doorAudio.play()  # Играем звук двери
			await doorAudio.finished  # Ждем, пока звук закончится
			print("Access done....")  # Выводим сообщение о завершении доступа
			set_marker_and_change_scene()  # Устанавливаем маркер и меняем сцену
			streetAudio.stop()  # Останавливаем аудио улицы

# Метод для установки маркера и смены сцены
func set_marker_and_change_scene():
	# Устанавливаем имя маркера для следующей сцены
	MarkerManager.player_spawn_marker_name = next_spawn_marker_name
	# Меняем сцену на указанную
	SceneTransitionManager.load_scene(next_scene)
