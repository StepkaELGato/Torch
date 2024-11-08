extends Area2D  # Наследуем класс Area2D для создания области, в которую могут входить другие узлы

@export var next_scene_path: String = "res://scenes/level_1.tscn"  # Путь к следующей сцене
@export var next_spawn_marker_name: String = "start_spawn_player_point"  # Имя маркера для спавна игрока в следующей сцене

@onready var officeAudio = $"../../officeAudio"  # Получаем ссылку на аудио офиса
@onready var doorAudio = $"../../doorAudio"  # Получаем ссылку на аудио двери
@onready var animationWay = $"../AnimationWay"  # Получаем ссылку на узел анимации пути

var entered_to_level: bool = false  # Флаг для отслеживания, находится ли игрок в зоне входа в уровень

func _ready() -> void:
	# Не обязательно инициализировать entered_to_level здесь, можно убрать
	# Подключаем сигналы для отслеживания входа и выхода из области
	self.body_entered.connect(_on_body_entered)  # Подключаем сигнал входа в область
	self.body_exited.connect(_on_body_exited)  # Подключаем сигнал выхода из области

func _input(event: InputEvent) -> void:
	# Проверяем нажатие клавиши взаимодействия
	if event.is_action_pressed("interaction") and entered_to_level:
		doorAudio.play()  # Воспроизводим звук двери
		await doorAudio.finished  # Ждем завершения звука двери
		print("Вход в левел")  # Выводим сообщение о входе в уровень
		set_marker_and_change_scene()  # Устанавливаем маркер и меняем сцену
		officeAudio.stop()  # Останавливаем звук офиса

func set_marker_and_change_scene() -> void:
	# Устанавливаем имя маркера для следующей сцены
	MarkerManager.player_spawn_marker_name = next_spawn_marker_name  # Устанавливаем имя маркера для спавна игрока
	# Меняем сцену
	SceneTransitionManager.load_scene(next_scene_path)  # Загружаем следующую сцену

func _on_body_entered(body: Node) -> void:
	# Проверяем, что в зону вошел игрок
	if body.is_in_group("Player"):  # Если объект в группе "Player"
		animationWay.play("RESET")  # Запускаем анимацию сброса
		entered_to_level = true  # Устанавливаем флаг, что игрок вошел в уровень

func _on_body_exited(body: Node) -> void:
	# Проверяем, что игрок вышел из зоны
	if body.is_in_group("Player"):  # Если объект в группе "Player"
		animationWay.play("way")  # Запускаем анимацию пути
		entered_to_level = false  # Устанавливаем флаг, что игрок вышел из уровня
