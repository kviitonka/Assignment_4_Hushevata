import uuid
import random
from datetime import datetime, timedelta
import psycopg2
from psycopg2.extras import execute_values
from faker import Faker

HOST = 'localhost'
USER = 'postgres'
PASSWORD = 'your password'
DATABASE = 'gym'
PORT = '5432'

fake = Faker()


def create_connection():
    try:
        connection = psycopg2.connect(
            host=HOST, port=PORT, user=USER, password=PASSWORD, dbname=DATABASE
        )
        print("Підключення до бази даних успішне!")
        return connection
    except Exception as e:
        print(f"Помилка підключення: '{e}'")
        return None


def generate_data():
    conn = create_connection()
    if not conn:
        return

    cursor = conn.cursor()

    print("Генеруємо клієнтів (members)...")
    members_data = []
    for _ in range(2000):
        members_data.append((
            str(uuid.uuid4()), fake.first_name(), fake.last_name(),
            fake.unique.email(), fake.unique.phone_number()[:20], True
        ))
    execute_values(cursor,
                   "INSERT INTO members (id, first_name, last_name, email, phone, active) VALUES %s",
                   members_data)

    print("Генеруємо фітнес-профілі...")
    profiles_data = []
    for m in members_data:
        cal = random.randint(1500, 3500)
        pro = int((cal * 0.3) / 4)
        carbs = int((cal * 0.4) / 4)
        fat = int((cal * 0.3) / 9)
        weight = round(random.uniform(50.0, 110.0), 2)
        profiles_data.append((str(uuid.uuid4()), m[0], cal, pro, carbs, fat, weight))
    execute_values(cursor,
                   "INSERT INTO fitness_profiles (id, member_id, calorie_goal, protein_goal, carbs_goal, fat_goal, current_weight) VALUES %s",
                   profiles_data)

    print("Генеруємо тренерів...")
    coaches_data = []
    specs = ['Crossfit', 'Yoga', 'Strength', 'Cardio', 'Pilates']
    for _ in range(50):
        coaches_data.append((str(uuid.uuid4()), fake.first_name(), fake.last_name(), random.choice(specs)))
    execute_values(cursor, "INSERT INTO coaches (id, first_name, last_name, specialization) VALUES %s", coaches_data)

    print("Генеруємо класи...")
    classes_data = []
    class_names = ['Morning Yoga', 'Hardcore Crossfit', 'TRX Basics', 'Pilates Core', 'Zumba']
    for name in class_names:
        classes_data.append((str(uuid.uuid4()), name, fake.text(max_nb_chars=100), random.randint(10, 30)))
    execute_values(cursor, "INSERT INTO group_classes (id, name, description, max_participants) VALUES %s",
                   classes_data)

    print("Генеруємо 500 000 візитів (gym_visits) батчами... Це займе трохи часу.")
    member_ids = [m[0] for m in members_data]
    visits_data = []
    start_date = datetime.now() - timedelta(days=365)

    for i in range(500000):
        m_id = random.choice(member_ids)
        entry = start_date + timedelta(days=random.randint(0, 365), hours=random.randint(6, 21),
                                       minutes=random.randint(0, 59))
        exit_time = entry + timedelta(minutes=random.randint(30, 180))
        visits_data.append((str(uuid.uuid4()), m_id, entry, exit_time))

        if len(visits_data) == 10000:
            execute_values(cursor, "INSERT INTO gym_visits (id, member_id, entry_time, exit_time) VALUES %s",
                           visits_data)
            visits_data = []
            print(f"Записано {i + 1} / 500000 візитів...")

    if visits_data:
        execute_values(cursor, "INSERT INTO gym_visits (id, member_id, entry_time, exit_time) VALUES %s", visits_data)

    conn.commit()
    cursor.close()
    conn.close()
    print("Генерацію даних успішно завершено!")


if __name__ == '__main__':
    generate_data()