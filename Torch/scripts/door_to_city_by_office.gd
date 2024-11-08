extends Area2D  # Наследуем класс Area2D для создания области взаимодействия

@export var next_scene_path: String = "res://scenes/city.tscn"  # Путь к следующей сцене
@export var next_spawn_marker_name: String = "out_with_office"  # Имя маркера для следующего появления игрока

@onready var officeAudio = $"../../officeAudio"  # Получаем ссылку на аудио офиса
@onready var doorAudio = $"../../doorAudio"  # Получаем ссылку на аудио двери

var entered: bool = false  # Переменная для отслеживания состояния входа игрока в область

func _ready() -> void:
	entered = false  # Инициализируем переменную entered как false
	# Подписываемся на сигналы для отслеживания входа/выхода из области
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	# Проверяем, что в зону вошел именно игрок (Player)
	if body.is_in_group("Player"):
		entered = true  # Устанавливаем entered в true, если это игрок

func _on_body_exited(body: Node) -> void:
	# Проверяем, что из зоны вышел именно игрок (Player)
	if body.is_in_group("Player"):
		entered = false  # Устанавливаем entered в false, если это игрок

func _input(event: InputEvent) -> void:
	# Проверяем, что игрок нажимает на кнопку взаимодействия и находится в зоне (entered)
	if Input.is_action_just_pressed("interaction") and entered:
		doorAudio.play()  # Воспроизводим звук двери
		await doorAudio.finished  # Ждем завершения звука
		print("Выход на улицу")  # Выводим сообщение в консоль
		set_marker_and_change_scene()  # Устанавливаем маркер и меняем сцену
		officeAudio.stop()  # Останавливаем звук офиса

func set_marker_and_change_scene() -> void:
	# Устанавливаем имя маркера для следующей сцены
	MarkerManager.player_spawn_marker_name = next_spawn_marker_name
	# Меняем сцену
	SceneTransitionManager.load_scene(next_scene_path)  # Загружаем следующую сцену по заданному пути
