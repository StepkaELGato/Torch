extends Area2D  # Наследуем класс Area2D для создания области, в которую могут входить другие узлы

@export var next_scene_path: String = "res://scenes/level_3.tscn"  # Путь к следующей сцене
@export var next_spawn_marker_name: String = "start_spawn_player_point"  # Имя маркера для спавна игрока в следующей сцене

@onready var animationWay = $"../AnimationWay"  # Получаем ссылку на узел анимации пути
@onready var levelAudio = $"../../levelAudio"  # Получаем ссылку на аудио уровня
@onready var doorAudio = $doorAudio  # Получаем ссылку на аудио двери

var is_door_active: bool = false  # Дверь изначально не активна
var player_inside: bool = false  # Флаг для отслеживания, находится ли игрок в области двери

# Ссылка на глобальный скрипт KillStates
var kill_states: KillStates = null  # Инициализируем переменную для хранения KillStates

func _ready() -> void:
	self.monitoring = false  # Отключаем отслеживание входа/выхода из области
	kill_states = get_node("/root/KillStates")  # Получаем ссылку на глобальный скрипт KillStates

# Функция для активации двери
func activate_door() -> void:
	is_door_active = true  # Устанавливаем дверь как активную
	self.monitoring = true  # Включаем возможность взаимодействия с дверью
	print("Дверь активирована")  # Выводим сообщение о том, что дверь активирована

func _on_body_entered(body: Node) -> void:
	# Проверяем, что дверь активна и вошел ли игрок
	if is_door_active and body.name == "Teo_Snorbest":
		player_inside = true  # Игрок вошел в область двери
		print("Игрок у двери.")  # Выводим сообщение о том, что игрок находится у двери

func _on_body_exited(body: Node) -> void:
	# Проверяем, что игрок вышел из области двери
	if body.name == "Teo_Snorbest":
		player_inside = false  # Игрок вышел из области двери
		print("Игрок покинул область двери.")  # Выводим сообщение о том, что игрок покинул область

func _process(delta: float) -> void:
	# Проверяем количество убийств и запускаем анимацию, если нужно
	if kill_states.kills >= 6:  # Если количество убийств 6 или больше
		animationWay.play("way")  # Запускаем анимацию пути
	
	# Проверяем, находится ли игрок в области и нажимает ли кнопку взаимодействия
	if player_inside and Input.is_action_just_pressed("interaction"):
		if kill_states.kills >= 6:  # Проверка на количество убийств
			doorAudio.play()  # Воспроизводим звук двери
			await doorAudio.finished  # Ждем завершения звука двери
			print("Переход на следующий уровень...")  # Выводим сообщение о переходе на следующий уровень
			set_marker_and_change_scene()  # Устанавливаем маркер и меняем сцену
			levelAudio.stop()  # Останавливаем звук уровня
		else:
			print("Ошибка: недостаточно убийств для перехода на следующий уровень.")  # Сообщение об ошибке
	elif player_inside:
		print("Нажмите кнопку взаимодействия для перехода на следующий уровень.")  # Инструкция для игрока

func set_marker_and_change_scene() -> void:
	# Устанавливаем имя маркера для следующей сцены
	MarkerManager.player_spawn_marker_name = next_spawn_marker_name  # Устанавливаем имя маркера для спавна игрока
	# Меняем сцену
	SceneTransitionManager.load_scene(next_scene_path)  # Загружаем следующую сцену