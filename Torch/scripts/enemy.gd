extends CharacterBody2D  # Наследуем от CharacterBody2D для управления телом персонажа

# Находим UI для отображения количества убийств
@onready var killed_bar: Control = $"../Label_kills/KilledBar"
# Находим узел AnimationPlayer для воспроизведения анимаций
@onready var animations = $AnimationPlayer

# Получаем узел глобального состояния убийств (счетчик убийств)
@onready var kill_manager = get_node("/root/KillStates")  # Проверьте правильность пути к узлу

@export var move_speed : float = 50  # Скорость передвижения врага

# Ссылки на необходимые дочерние узлы для таймера перезарядки, эффектов, таймера повреждений, меча и изображения врага
@onready var cooldown_timer = $CooldownTimer
@onready var effects = $Effects
@onready var hurtTimer = $hurtTimer
@onready var sword_sprite = $weapon/Sword_Enemy/Sprite2D
@onready var sprite = $Enemy_image
@onready var weapon = $weapon
@onready var hitBox = $Hitbox/CollisionShape2D
@onready var detectionArea = $Detection_area/CollisionShape2D

var lastAnimDirection: String = "Down"  # Направление последней анимации для продолжения движения

# Звуковые эффекты для шагов, таймера шагов, урона и атаки
@onready var footStepAudio = $footStepsAudio
@onready var stepTimer = $stepTimer
@onready var damageAudio = $damageAudio
@onready var attackAudio = $attackAudio

var move_direction : Vector2 = Vector2.ZERO  # Направление движения врага

# Заранее загружаем сцену для выпадения лута (например, монеты)
var loot_scene = preload("res://scenes/coin.tscn")  # Замените путь на вашу сцену лута

var direction: String = "Left"  # Начальное направление движения врага
var isHurt: bool = false  # Флаг, указывающий, что враг поврежден
var isAttacking: bool = false  # Флаг, указывающий, что враг атакует
var health = 3  # Количество здоровья врага
signal enemy_died  # Сигнал, испускаемый при смерти врага

var dead = false  # Флаг, указывающий, что враг мертв
var player_in_area = false  # Флаг, указывающий, что игрок находится в зоне обнаружения
var player: Node2D  # Ссылка на узел игрока

@export var stop_distance: float = 20  # Минимальное расстояние до игрока для остановки преследования
@export var attack_distance: float = 50  # Расстояние для перехода к атаке
@export var detection_distance: float = 200  # Зона, в которой враг обнаруживает игрока

# Перечисление состояний врага: покой (IDLE), преследование (CHASE), атака (ATTACK)
enum State {
	IDLE,
	CHASE,
	ATTACK
}

var current_state: State = State.IDLE  # Начальное состояние врага - покой

# Функция, вызываемая при готовности узла
func _ready() -> void:
	dead = false  # Устанавливаем, что NPC жив
	add_to_group("NPC")  # Добавляем NPC в группу "NPC" для управления группой

# Обработка физики каждого кадра
func _physics_process(delta: float) -> void:
	# Если NPC жив
	if !dead:
		updateAnimation()  # Обновляем текущую анимацию
		if player:
			# Рассчитываем расстояние до игрока
			var distance_to_player = position.distance_to(player.position)
			
			# В зависимости от состояния NPC выполняем соответствующую логику
			match current_state:
				State.IDLE:
					handle_idle_state(distance_to_player)  # Обрабатываем состояние покоя
				State.CHASE:
					handle_chase_state(distance_to_player)  # Обрабатываем состояние преследования
				State.ATTACK:
					handle_attack_state(distance_to_player)  # Обрабатываем состояние атаки
		
		# Перемещаем NPC с учетом коллизий
		move_and_slide()
		
		updateAudio()  # Обновляем аудио для шагов и других эффектов
	
	# Если NPC мертв
	if dead:
		$Detection_area/CollisionShape2D.disabled = true  # Отключаем область обнаружения
		queue_free()  # Удаляем NPC из сцены

# Обработка состояния покоя
func handle_idle_state(distance_to_player: float) -> void:
	velocity = Vector2.ZERO  # NPC стоит на месте
	
	# Если игрок находится в зоне обнаружения
	if distance_to_player <= detection_distance:
		print("Обнаружен игрок, преследуем!")
		current_state = State.CHASE  # Переходим в состояние преследования

# Обработка состояния преследования
func handle_chase_state(distance_to_player: float) -> void:
	# Если игрок ушел из зоны обнаружения
	if distance_to_player > detection_distance:
		print("Игрок скрылся из виду, возвращаемся в состояние покоя.")
		current_state = State.IDLE  # Переход в состояние покоя
	# Если игрок достаточно близко для атаки
	elif distance_to_player <= attack_distance:
		print("Игрок близко! Атакуем!")
		current_state = State.ATTACK  # Переход в состояние атаки
	else:
		# Направляем NPC к игроку
		velocity = (player.position - position).normalized() * move_speed
	# Если игрок вблизи, NPC останавливается
	if distance_to_player < stop_distance:
		velocity = Vector2.ZERO

# Обработка состояния атаки
func handle_attack_state(distance_to_player: float) -> void:
	velocity = Vector2.ZERO  # NPC не двигается во время атаки
	
	# Если игрок слишком далеко для атаки
	if distance_to_player > attack_distance:
		print("Игрок слишком далеко для атаки, продолжаем преследование.")
		current_state = State.CHASE  # Переход к преследованию

	# Логика атаки NPC (например, уменьшение здоровья игрока)
	attack()
	velocity = (player.position - position).normalized() * move_speed  # NPC подходит к игроку для атаки
	
	# Если игрок вблизи, NPC снова останавливается
	if distance_to_player < stop_distance:
		velocity = Vector2.ZERO


# Обновление анимации NPC в зависимости от состояния и направления движения
func updateAnimation():
	if isAttacking: return  # Если NPC атакует, анимация не обновляется
	
	# Если NPC не движется
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()  # Останавливаем анимацию, если она играет
	else:
		# Если NPC движется влево
		if velocity.x < 0:
			sprite.flip_h = false  # Не переворачиваем спрайт
			animations.play("walkLeft")  # Запускаем анимацию ходьбы влево
			direction = "Left"  # Устанавливаем направление
		# Если NPC движется вправо
		elif velocity.x > 0:
			sprite.flip_h = true  # Переворачиваем спрайт
			animations.play("walkLeft")  # Запускаем анимацию ходьбы влево (изменить на "walkRight" если требуется)
			direction = "Right"  # Устанавливаем направление
		lastAnimDirection = direction  # Обновляем последнее направление анимации

# Логика атаки NPC
func attack():
	if !cooldown_timer.is_stopped():
		return  # Если таймер перезарядки не остановлен, ничего не делаем
	
	# Воспроизводим соответствующую анимацию атаки в зависимости от направления
	if lastAnimDirection == "Left":
		animations.play("attackLeft")
	else:
		animations.play("attackRight")
	
	isAttacking = true  # Устанавливаем флаг атаки
	weapon.enable()  # Активируем оружие
	await animations.animation_finished  # Ждем окончания анимации атаки
	attackAudio.play()  # Проигрываем звук атаки
	weapon.disable()  # Деактивируем оружие
	isAttacking = false  # Сбрасываем флаг атаки
	animations.play("RESET")  # Возвращаемся к основной анимации
	cooldown_timer.start()  # Запускаем таймер перезарядки

# Обработчик события, когда объект входит в область обнаружения
func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = true  # Устанавливаем флаг, что игрок в зоне обнаружения
		player = body  # Сохраняем ссылку на игрока

# Обработчик события, когда объект покидает область обнаружения
func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_in_area = false  # Сбрасываем флаг, что игрок покинул зону обнаружения

# Метод получения урона
func take_damage(damage: int):
	health = health - damage  # Уменьшаем здоровье на полученный урон
	damageAudio.play()  # Проигрываем звук получения урона
	
	# Если здоровье ниже 1, NPC умирает
	if health < 1:
		hitBox.set_deferred("disabled", true)  # Отключаем хитбокс
		detectionArea.set_deferred("disabled", true)  # Отключаем область обнаружения
		die()  # Вызываем метод смерти
	isHurt = true  # Устанавливаем флаг, что NPC получает урон
	effects.play("hurtBlink")  # Воспроизводим эффект урона (мерцание)
	hurtTimer.start()  # Запускаем таймер для восстановления после урона
	await hurtTimer.timeout  # Ждем окончания таймера
	effects.play("RESET")  # Сбрасываем эффекты
	isHurt = false  # Сбрасываем флаг получения урона

# Метод смерти NPC
func die():
	call_deferred("drop_loot")  # Вызываем метод выпадения лута
	kill_manager.enemy_killed()  # Увеличиваем счетчик убитых врагов
	queue_free()  # Удаляем NPC из сцены

# Метод NPC (возможно, заглушка для дальнейшей логики)
func NPC():
	pass

# Метод выпадения лута
func drop_loot():
	var random_number = randi() % 100  # Генерируем случайное число от 0 до 99
	if random_number < 90:  # 90% шанс на выпадение
		var loot_instance = loot_scene.instantiate()  # Создаем экземпляр сцены лута
		loot_instance.position = position  # Устанавливаем позицию лута
		get_parent().add_child(loot_instance)  # Добавляем лут в родительский узел

# Обработчик события таймера перезарядки (пока не реализован)
func _on_cooldown_timer_timeout() -> void:
	pass # Здесь можно добавить логику для завершения перезарядки

# Обновление аудио в зависимости от движения NPC
func updateAudio():
	# Если NPC движется
	if velocity != Vector2.ZERO:
		if stepTimer.is_stopped():  # Проверяем, остановлен ли таймер шагов
			stepTimer.start()  # Запускаем таймер
			footStepAudio.play()  # Проигрываем звук шага
	else:
		stepTimer.stop()  # Останавливаем таймер, если персонаж не двигается

# Обработчик события таймера шагов
func _on_step_timer_timeout() -> void:
	if velocity != Vector2.ZERO:  # Если NPC движется
		footStepAudio.play()  # Проигрываем звук шага
		stepTimer.start()  # Перезапускаем таймер для следующего шага
