extends Control  # Наследуем класс Control для создания UI элементов

@onready var heal_menu = $"."  # Находим меню для покупки (в данном случае текущий узел)
@onready var buttonAudio = $buttonAudio  # Получаем ссылку на аудио кнопки

# Стоимость лечения
var heal_cost = 2  # Определяем стоимость лечения
# Количество восстанавливаемого здоровья
var heal_amount = 1  # Указываем, сколько здоровья восстанавливается

# Этот метод вызывается, когда узел входит в дерево сцен в первый раз.
func _ready() -> void:
	heal_menu.visible = false  # Скрываем меню при старте

# Метод, вызываемый при нажатии кнопки "Купить"
func _on_buy_btn_pressed() -> void:
	print("Покупка кофе")  # Выводим сообщение о покупке
	buttonAudio.play()  # Проигрываем звук кнопки
	await buttonAudio.finished  # Ждем завершения звука

	var player = get_player()  # Находим игрока
	if player.coins >= heal_cost:  # Проверяем, хватает ли монет
		if player.currentHealth < player.maxHealth:  # Проверяем, нужно ли лечение
			player.heal()  # Вызов функции лечения персонажа, которая увеличит здоровье на 1
			player.coins -= heal_cost  # Уменьшаем количество монет
			player.update_coin_label()  # Обновляем отображение монет в UI
			heal_menu.visible = false  # Закрываем меню после покупки
			print("Здоровье увеличено на 1!")  # Сообщение об успешном лечении
		else:
			print("HP уже на максимуме!")  # Если здоровье уже максимальное
	else:
		print("Недостаточно монет!")  # Если недостаточно монет для покупки

# Метод, вызываемый при нажатии кнопки "Нет" в меню
func _on_no_buy_btn_pressed() -> void:
	buttonAudio.play()  # Проигрываем звук кнопки
	await buttonAudio.finished  # Ждем завершения звука
	hide()  # Скрываем меню

# Метод для получения узла игрока
func get_player():
	# Возвращаем узел игрока. Убедитесь, что путь правильный
	return get_node("../../Teo_Snorbest")  # Указываем путь к узлу игрока
