FROM python:3.9-slim
WORKDIR /app
COPY ./app /app
RUN pip install Flask
CMD ["python", "hellow.py"]