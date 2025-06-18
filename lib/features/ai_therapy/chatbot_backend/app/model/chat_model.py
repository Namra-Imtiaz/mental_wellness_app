import sqlite3
from datetime import datetime, timedelta

DB_PATH = "app/db.sqlite3"

class ChatModel:
    def __init__(self):
        self.conn = sqlite3.connect(DB_PATH, check_same_thread=False)
        self.create_table()

    def create_table(self):
        self.conn.execute('''
            CREATE TABLE IF NOT EXISTS chats (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                device TEXT,
                query TEXT,
                response TEXT,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        self.conn.commit()

    def allow_request(self, device):
        one_hour_ago = datetime.now() - timedelta(hours=1)
        cur = self.conn.cursor()
        cur.execute("SELECT COUNT(*) FROM chats WHERE device=? AND timestamp > ?", (device, one_hour_ago))
        count = cur.fetchone()[0]
        return count < 12

    def save_chat(self, device, query, response):
        self.conn.execute("INSERT INTO chats (device, query, response) VALUES (?, ?, ?)", (device, query, response))
        self.conn.commit()
