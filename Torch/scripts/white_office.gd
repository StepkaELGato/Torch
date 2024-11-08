extends Area2D  # Наследуем класс Area2D для создания области взаимодействия

@export var next_scene_path = "res://scenes/reseption.tscn"  # Путь к следующей сцене
@export var next_spawn_marker_name = "start_spawn_player_point"  # Имя маркера для спавна игрока в следующей сцене

@onready var streetAudio = $"../../streetAudio"  # Ссылка на аудио улицы
@onready var doorAudio = $"../../doorAudio"  # Ссылка на аудио двери
@onready var animationWay = $"../way"  # Ссылка на анимацию движения

var entered = false  # Флаг для отслеживания, находится ли игрок в области

# Метод, вызываемый при инициализации узла
func _ready() -> void:
	animationWay.play("way")  # Запускаем анимацию движения
	entered = false  # Изначально игрок не находится в области
	
# Метод для обработки ввода событий
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("interaction") && entered == true:  # Проверяем нажатие клавиши взаимодействия и статус флага entered
		doorAudio.play()  # Воспроизводим звук двери
		await doorAudio.finished  # Ждем окончания воспроизведения звука
		print("Access done....")  # Логируем доступ
		set_marker_and_change_scene()  # Устанавливаем маркер и меняем сцену
		streetAudio.stop()  # Останавливаем звук улицы


# Метод для установки маркера и смены сцены
func set_marker_and_change_scene():
	# Устанавливаем имя маркера для следующей сцены
	MarkerManager.player_spawn_marker_name = next_spawn_marker_name
	# Меняем сцену на указанную
	SceneTransitionManager.load_scene(next_scene_path)


# Метод, вызываемый при входе в область
func _on_area_entered(area: Area2D) -> void:
	print("Enter office")  # Логируем вход в офис
	animationWay.stop()  # Останавливаем анимацию движения
	animationWay.play("RESET")  # Запускаем анимацию сброса
	entered = true  # Устанавливаем флаг entered в true


# Метод, вызываемый при выходе из области
func _on_area_exited(area: Area2D) -> void:
	print("Not enter office")  # Логируем выход из офиса
	animationWay.play("way")  # Возвращаемся к анимации движения
	entered = false  # Сбрасываем флаг entered
