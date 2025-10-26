FROM python:3.11-slim
WORKDIR /app

# Siapkan dependency
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Salin source code
COPY . .

EXPOSE 5000
CMD ["python", "app.py"]
