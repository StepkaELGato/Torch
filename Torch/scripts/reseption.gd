extends Node2D  # Наследуем класс Node2D для создания узла в 2D-сцене

@onready var officeAudio = $officeAudio  # Ссылка на аудио узел, отвечающий за звук офиса
@onready var dialogWindow = $Dialog  # Ссылка на окно диалога
@onready var timer = $Dialog/DialogOffice/Timer

# Вызывается, когда узел впервые входит в дерево сцен.
func _ready() -> void:
	timer.start()
	await timer.timeout
	dialogWindow.visible = true  # Делаем окно диалога видимым
	officeAudio.play()  # Запускаем воспроизведение звука офиса

# Вызывается, когда аудио офиса завершает воспроизведение
func _on_office_audio_finished() -> void:
	officeAudio.play()  # Запускаем воспроизведение аудио офиса заново
