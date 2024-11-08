extends Area2D  # Наследуем от Area2D, чтобы создать зону взаимодействия, которая может обнаруживать объекты в своей области

# Получаем ссылки на узлы: спрайт и форму столкновения
@onready var sprite: Sprite2D = $Sprite2D  # Спрайт, визуальное представление оружия
@onready var shape = $CollisionShape2D  # Форма столкновения, используемая для определения области удара оружия

# Активируем оружие, делая его видимым и включаем область столкновения
func enable():
	shape.disabled = false  # Включаем столкновение, чтобы обнаруживать контакты с объектами
	sprite.visible = true  # Делаем спрайт видимым

# Деактивируем оружие, делая его невидимым и отключаем область столкновения
func disable():
	shape.disabled = true  # Отключаем столкновение, чтобы не обнаруживать объекты
	sprite.visible = false  # Скрываем спрайт

# Обработчик события, срабатывающий при входе объекта в область удара
func _on_body_entered(body: Node2D) -> void:
	# Проверяем, имеет ли объект метод "NPC" (проверка, что это враг)
	if body.has_method("NPC"):
		body.take_damage(1)  # Наносим 1 единицу урона объекту, вызвав его метод take_damage()