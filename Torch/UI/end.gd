extends Node  # Наследуем класс Node для создания узла в сцене

@onready var buttonAudio = $buttonAudio  # Получаем ссылку на звук кнопки
@onready var endAudio = $endAudio  # Получаем ссылку на звук завершения

var next_scene_path  # Переменная для хранения пути к следующей сцене

# Этот метод вызывается, когда узел входит в дерево сцен в первый раз.
func _ready() -> void:
	get_tree().paused = false  # Снимаем паузу, если она была активна
	endAudio.play()  # Проигрываем звук завершения

# Этот метод вызывается каждый кадр. 'delta' — это время, прошедшее с предыдущего кадра.
func _process(delta: float) -> void:
	pass  # Пока ничего не делаем в процессе

# Метод, вызываемый при нажатии кнопки выхода
func _on_quit_btn_pressed() -> void:
	buttonAudio.play()  # Проигрываем звук кнопки
	await buttonAudio.finished  # Ждем завершения звука
	get_tree().paused = true  # Ставим игру на паузу
	get_tree().change_scene_to_file("res://scenes/menu.tscn")  # Меняем сцену на главное меню
