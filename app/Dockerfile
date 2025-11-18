FROM python:3.13.3-alpine

RUN adduser \
    --disabled-password \
    --home /home/app_user \
    --shell /bin/bash \
    app_user

WORKDIR /home/app_user

COPY Pipfile Pipfile.lock ./

RUN pip install --no-cache-dir --upgrade pip==24.0 && \
    pip install --no-cache-dir pipenv==2023.12 && \
    pipenv install --system --deploy

ENV PORT=8080

RUN apk upgrade libexpat

WORKDIR /home/app_user

USER app_user

COPY . .

CMD ["python", "app.py"]
