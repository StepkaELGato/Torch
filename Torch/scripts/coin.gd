extends Area2D  # Наследуем класс Area2D для создания области взаимодействия

signal coin_collected  # Сигнал, который будет испускаться при сборе монеты

@onready var animations = $AnimationPlayer  # Получаем ссылку на AnimationPlayer для управления анимацией

func _ready() -> void:
	animations.play("idle")  # Воспроизводим анимацию "idle" при инициализации

func _on_body_entered(body: Node2D) -> void:
	# Обработчик события, когда тело входит в область
	if body.has_method("add_coins"):  # Проверяем, что объект имеет метод "add_coins" (например, это игрок)
		emit_signal("coin_collected")  # Испускаем сигнал о сборе монеты
		body.add_coins(1)  # Добавляем игроку 1 монету
		queue_free()  # Удаляем монету из сцены, чтобы она больше не была доступна
