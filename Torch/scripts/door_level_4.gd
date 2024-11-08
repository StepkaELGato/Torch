extends Node2D  # Наследуем класс Node2D для создания узла в 2D-пространстве

@export var next_scene_path: String = "res://UI/end.tscn"  # Путь к следующей сцене

@onready var levelAudio = $"../../levelAudio"  # Получаем ссылку на аудио уровня
@onready var doorAudio = $doorAudio  # Получаем ссылку на аудио двери
@onready var animationWay = $"../AnimationWay"  # Получаем ссылку на анимацию пути

var is_door_active: bool = false  # Дверь изначально не активна
var player_inside: bool = false  # Флаг для отслеживания, находится ли игрок в области двери

# Ссылка на глобальный скрипт KillStates
var kill_states: KillStates = null  # Инициализируем переменную для хранения KillStates

func _ready() -> void:
	get_tree().paused = false  # Разблокируем дерево сцен
	self.monitoring = false  # Отключаем отслеживание входа/выхода
	kill_states = get_node("/root/KillStates")  # Получаем ссылку на глобальный скрипт KillStates

# Функция для активации двери
func activate_door() -> void:
	is_door_active = true  # Устанавливаем дверь как активную
	self.monitoring = true  # Включаем возможность взаимодействия
	print("Дверь активирована")  # Выводим сообщение в консоль

func _on_body_entered(body: Node) -> void:
	# Проверяем, что дверь активна и вошел ли игрок
	if is_door_active and body.name == "Teo_Snorbest":
		player_inside = true  # Игрок вошел в область двери
		print("Игрок у двери.")  # Выводим сообщение в консоль

func _on_body_exited(body: Node) -> void:
	# Проверяем, что игрок вышел из области двери
	if body.name == "Teo_Snorbest":
		player_inside = false  # Игрок вышел из области двери
		print("Игрок покинул область двери.")  # Выводим сообщение в консоль

func _process(delta: float) -> void:
	# Проверяем количество убийств и запускаем анимацию, если нужно
	if kill_states.kills >= 7:
		animationWay.play("way")  # Запускаем анимацию пути
	
	# Проверяем количество убийств и состояние игрока
	if player_inside and Input.is_action_just_pressed("interaction"):
		if kill_states.kills >= 7:  # Проверка на количество убийств
			doorAudio.play()  # Воспроизводим звук двери
			await doorAudio.finished  # Ждем завершения звука
			print("Переход на следующий уровень...")  # Выводим сообщение в консоль
			set_marker_and_change_scene()  # Устанавливаем маркер и меняем сцену
			levelAudio.stop()  # Останавливаем звук уровня
		else:
			print("Ошибка: недостаточно убийств для перехода на следующий уровень.")  # Сообщение об ошибке
	elif player_inside:
		print("Нажмите кнопку взаимодействия для перехода на следующий уровень.")  # Инструкция для игрока

func set_marker_and_change_scene() -> void:
	get_tree().change_scene_to_file(next_scene_path)  # Меняем сцену на указанную
