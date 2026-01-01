"""Seed script для заповнення бази даних фейковими даними."""

import sqlite3
from faker import Faker

fake = Faker()

conn = sqlite3.connect("/Users/olegoleg/Desktop/task_project_HW_2/tasks_HW_2.db")
cursor = conn.cursor()

# ОБОВʼЯЗКОВО для SQLite
cursor.execute("PRAGMA foreign_keys = ON;")

# --- СТВОРЕННЯ ТАБЛИЦЬ ---
cursor.executescript("""
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    status_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (status_id) REFERENCES status(id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
""")

# --- СТАТУСИ ---
statuses = ['new', 'in progress', 'completed']
for status in statuses:
    cursor.execute(
        "INSERT OR IGNORE INTO status (name) VALUES (?)",
        (status,)
    )

# --- КОРИСТУВАЧІ ---
NUM_USERS = 10
for _ in range(NUM_USERS):
    cursor.execute(
        "INSERT INTO users (fullname, email) VALUES (?, ?)",
        (fake.name(), fake.unique.email())
    )

# --- ЗАВДАННЯ ---
NUM_TASKS = 20
for _ in range(NUM_TASKS):
    cursor.execute(
        """
        INSERT INTO tasks (title, description, status_id, user_id)
        VALUES (?, ?, ?, ?)
        """,
        (
            fake.sentence(nb_words=6),
            fake.text(max_nb_chars=100),
            fake.random_int(min=1, max=3),
            fake.random_int(min=1, max=NUM_USERS),
        )
    )

conn.commit()
conn.close()

print("База створена і заповнена ✅")
