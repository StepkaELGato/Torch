extends Control  # Наследуем класс Control для создания пользовательского интерфейса

@onready var buttonAudio = $buttonAudio  # Получаем ссылку на звук кнопки
@onready var deadAudio = $deadAudio  # Получаем ссылку на звук для игрового завершения

# Этот метод вызывается, когда узел входит в дерево сцен.
func _ready() -> void:
	if get_tree().paused:
		get_tree().paused = false  # Снимаем паузу, если она была активна
	print("Готово к движению, пауза:", get_tree().paused)  # Выводим состояние паузы в консоль
	self.hide()  # Скрываем текущий узел

# Этот метод вызывается каждый кадр. 'delta' — это время, прошедшее с предыдущего кадра.
func _process(delta: float) -> void:
	pass  # Пока ничего не делаем в процессе

# Метод, вызываемый при нажатии кнопки респауна
func _on_respawn_btn_pressed() -> void:
	buttonAudio.play()  # Проигрываем звук кнопки
	await buttonAudio.finished  # Ждем завершения звука
	restart_scene()  # Перезапускаем сцену

# Метод, вызываемый при нажатии кнопки выхода
func _on_quit_btn_pressed() -> void:
	buttonAudio.play()  # Проигрываем звук кнопки
	await buttonAudio.finished  # Ждем завершения звука
	hide()  # Скрываем текущий узел
	var menu_Scene = load("res://scenes/menu.tscn").instantiate()  # Загружаем сцену меню
	add_child(menu_Scene)  # Добавляем сцену меню как дочерний узел

# Метод для перезапуска сцены
func restart_scene():
	#var current_scene = get_tree().current_scene  # Можно использовать для получения текущей сцены
	var respawn_marker_1 = get_tree().current_scene.get_node("start_spawn_player_point")  # Получаем маркер для респауна
	if respawn_marker_1:  # Если маркер существует
		global_position = respawn_marker_1.global_position  # Перемещаемся на позицию маркера
	self.hide()  # Скрываем узел
	get_tree().paused = false  # Снимаем паузу
	get_tree().reload_current_scene()  # Перезагружаем текущую сцену

# Метод, вызываемый при нажатии кнопки перезапуска игры
func _on_restart_game_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/teo_house.tscn")  # Меняем сцену на дом игрока

# Метод для обработки завершения игры
func game_over():
	get_tree().paused = true  # Ставим игру на паузу
	self.show()  # Показываем текущий узел
	deadAudio.play()  # Проигрываем звук завершения игры
