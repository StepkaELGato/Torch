extends Node  # Наследуем класс Node для создания логики игры

var player_health = 3  # Текущее здоровье игрока
var max_health = 3  # Максимальное здоровье
var start_scene = false  # Состояние начала сцены

signal killed  # Сигнал, который будет испускаться при убийстве

var enemies_killed = 0  # Счетчик убитых врагов

# Функция, вызываемая при убийстве врага
func enemy_killed():
	enemies_killed += 1  # Увеличиваем счетчик убитых врагов на 1
	emit_signal("killed")  # Испускаем сигнал "killed"

# Устанавливает значение здоровья игрока
func set_health(value):
	player_health = value  # Устанавливаем текущее здоровье на указанное значение
	
# Возвращает текущее здоровье игрока
func get_health():
	return player_health  # Возвращаем текущее здоровье игрока
	
# Устанавливает состояние начала сцены
func set_start_scene(scene_state: bool):
	start_scene = scene_state  # Устанавливаем состояние начала сцены

# Возвращает состояние начала сцены
func get_start_scene():
	return start_scene  # Возвращаем состояние начала сцены

# Увеличение здоровья (лечим игрока)
func heal_player(heal_amount):
	if player_health < max_health:  # Проверяем, если текущее здоровье меньше максимального
		player_health += heal_amount  # Увеличиваем здоровье на указанное количество
		player_health = clamp(player_health, 0, max_health)  # Не превышаем максимум
	else:
		print("Здоровье уже максимальное!")  # Сообщение о том, что здоровье уже максимальное
