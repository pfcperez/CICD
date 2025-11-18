# 1. Base Image: Moderna, segura y ligera (Debian 12 "Bookworm")
FROM python:3.11-slim-bookworm

# 2. Establecer el directorio de trabajo (donde vivirá la app)
WORKDIR /webapp

# 3. Copiar PRIMERO las dependencias
# (El "." significa "copia al WORKDIR actual, /webapp")
COPY ./requirements.txt .
COPY roberta-sequence-classification-9.onnx /webapp

# 4. Instalar las dependencias (con optimizaciones)
#    - Actualizamos pip
#    - --no-cache-dir mantiene la imagen ligera
#    ¡ADVERTENCIA: Este paso tardará MUCHO por culpa de PyTorch!
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# 5. Copiar el resto del código de la aplicación
#    (Asume que tu app.py está en una carpeta local 'webapp')
COPY ./webapp .

# 6. Definir el comando de producción (usando Gunicorn)
#    (Reemplaza el "ENTRYPOINT" y "CMD" del libro)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]