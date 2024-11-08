extends Node2D  # Наследуем класс Node2D для определения узла, представляющего дом

@onready var dialogWindow = $Dialog  # Ссылка на окно диалога
@onready var houseAudio = $houseAudio  # Ссылка на аудио дома

# Метод, вызываемый при первой загрузке сцены
func _ready() -> void:
	get_tree().paused = false  # Разблокируем игровое дерево (снимаем паузу)
	Global.set_health(3)  # Устанавливаем здоровье игрока на 3
	Global.set_start_scene(true)  # Устанавливаем флаг, что это начальная сцена
	houseAudio.play()  # Проигрываем аудио дома
	
	dialogWindow.visible = true  # Делаем окно диалога видимым

# Обработчик события, когда аудио дома заканчивается
func _on_house_audio_finished() -> void:
	houseAudio.play()  # Проигрываем аудио дома снова
