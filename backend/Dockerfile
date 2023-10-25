FROM python:3.9

WORKDIR /backend

COPY requirements.txt requirements.txt

RUN pip install -r requirements.txt

COPY . .

ENV FLASK_APP app.py

# Install gunicorn
RUN pip install gunicorn

CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:5000"]
