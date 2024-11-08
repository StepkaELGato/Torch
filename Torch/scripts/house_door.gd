extends Area2D  # Наследуем класс Area2D для создания области, в которой будут обрабатываться события

@export var next_spawn_marker_name = "start_spawn_player_point"  # Имя маркера, куда будет телепортироваться игрок при переходе в следующую сцену

@onready var animationWay = $"../Way"  # Получаем ссылку на узел анимации пути
@onready var houseAudio = $"../../houseAudio"  # Получаем ссылку на аудио для дома
@onready var doorAudio = $doorAudio  # Получаем ссылку на аудио двери

var entered = false  # Переменная для отслеживания, находится ли игрок в области

func _ready() -> void:
	animationWay.play("way")  # Запускаем анимацию пути при готовности узла
	entered = false  # Устанавливаем флаг entered в false при старте
	SceneTransitionManager.visible = false  # Скрываем менеджер переходов при старте

# Функция вызывается, когда объект входит в область
func _on_body_entered(body):
	animationWay.play("RESET")  # Запускаем анимацию сброса
	entered = true  # Устанавливаем флаг entered в true

# Функция вызывается, когда объект покидает область
func _on_body_exited(body):
	animationWay.play("way")  # Запускаем анимацию пути при выходе
	entered = false  # Устанавливаем флаг entered в false

# Обработка входящих событий
func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("interaction"):  # Проверяем, нажата ли клавиша взаимодействия
		if get_overlapping_bodies().size() > 0:  # Проверяем, есть ли объекты в области
			doorAudio.play()  # Играем звук двери
			await doorAudio.finished  # Ожидаем завершения звука двери
			print("Access done....")  # Сообщаем, что доступ выполнен
			SceneTransitionManager.visible = true  # Показываем менеджер переходов
			set_marker_and_change_scene()  # Устанавливаем маркер и меняем сцену
			houseAudio.stop()  # Останавливаем аудио дома

# Функция для установки маркера и смены сцены
func set_marker_and_change_scene():
	# Устанавливаем имя маркера для следующей сцены
	MarkerManager.player_spawn_marker_name = next_spawn_marker_name
	
	# Меняем сцену на город
	SceneTransitionManager.load_scene("res://scenes/city.tscn")
	print ("anim played =?")  # Выводим сообщение для отладки
