extends Node  # Наследуем класс Node для создания узла в сцене

@onready var door_level_4: Area2D = $Door_to_level4/doorLevel4  # Получаем ссылку на Area2D двери для перехода на уровень 4
@onready var kills_label: Label = get_node_or_null("res://KillsLabel.tscn")  # Получаем ссылку на Label для отображения количества убийств

@onready var levelAudio = $levelAudio  # Получаем ссылку на аудио узел уровня

# Вызывается, когда узел впервые входит в дерево сцен.
func _ready() -> void:
	levelAudio.play()  # Запускаем аудио уровня при старте
	
	# Сбрасываем количество убийств при запуске новой сцены
	KillStates.reset_kills()  # Обнуляем счетчик убийств

	# Передаем узел двери в KillStates для управления состоянием перехода
	if KillStates:
		KillStates.set_door(door_level_4)  # Передаем узел двери в KillStates
	else:
		print("Ошибка: KillStates не найден")  # Выводим ошибку, если KillStates не найден
	#
	if KillStates and kills_label:
		KillStates.set_kills_label(kills_label)  # Устанавливаем Label в KillStates для отображения количества убийств
		KillStates.set_required_kills(7)  # Устанавливаем, что нужно убить 7 врагов для перехода
	else:
		print("Ошибка: KillStates или KillsLabel не найдены {level 3}")  # Выводим ошибку, если KillStates или KillsLabel не найдены

# Вызывается, когда аудио уровня заканчивается
func _on_level_audio_finished() -> void:
	levelAudio.play()  # Снова запускаем аудио уровня, если оно завершилось
