extends Node  # Наследуем класс Node для создания логики игры

# Переменная для хранения нужного маркера
var target_marker = null
var start_player_position : Vector2 = Vector2(153, 103)  # Начальная позиция игрока
# Имя маркера спауна
var player_spawn_marker_name : String = "start_spawn_player_point" 		 	

# Вызывается, когда узел впервые входит в дерево сцен
func _ready():
	find_marker()  # Ищем маркер спауна при инициализации

# Функция для поиска маркера спауна в текущей сцене
func find_marker():
	var marker = get_tree().current_scene.get_node_or_null(player_spawn_marker_name)  # Ищем маркер по имени
	if marker:  # Если маркер найден
		start_player_position = marker.global_position  # Сохраняем позицию маркера как стартовую
		print("Found marker: ", player_spawn_marker_name, " at position: ", start_player_position)  # Выводим информацию о маркере
	else:  # Если маркер не найден
		print("Using default spawn position: ", start_player_position)  # Выводим сообщение о том, что используется стандартная позиция

# Вызовите эту функцию после перезагрузки сцены для обновления позиции персонажа
func update_player_position(player):
	player.global_position = start_player_position  # Устанавливаем позицию игрока в стартовую
	print("Player moved to spawn position: ", start_player_position)  # Выводим информацию о перемещении игрока
