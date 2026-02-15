FROM python:3.10-slim

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Создание рабочей директории
WORKDIR /app

# Копирование зависимостей
COPY requirements.txt /app/

# Установка зависимостей через pip
RUN pip install --no-cache-dir -r requirements.txt gunicorn psycopg2-binary

# Копирование всего проекта
COPY . /app

# Сборка статики
RUN cd /app/mysite && python manage.py collectstatic --noinput

# Экспозиция порта
EXPOSE 8000

# Запуск приложения
WORKDIR /app/mysite
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "mysite.wsgi:application"]