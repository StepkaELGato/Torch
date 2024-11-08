extends Area2D  # Наследуем класс Area2D, который позволяет отслеживать пересечения с другими объектами

@onready var shape = $CollisionShape2D  # Получаем ссылку на CollisionShape2D для управления столкновениями

# Метод для активации области столкновения
func enable():
	shape.disabled = false  # Включаем столкновение, устанавливая disabled в false

# Метод для деактивации области столкновения
func disable():
	shape.disabled = true  # Отключаем столкновение, устанавливая disabled в true

# Обработчик события, когда другой объект входит в область
func _on_body_entered(body: Node2D) -> void:
	# Проверяем, имеет ли объект метод "player", что указывает на его принадлежность к классу игрока
	if body.has_method("player"):
		body.damage(1)  # Наносим 1 единицу урона игроку
