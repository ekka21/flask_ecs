FROM python:3.7.6-slim

RUN useradd -r -s /bin/bash app_user
ENV HOME /app
WORKDIR /app
ENV PATH="/app/.local/bin:${PATH}"

RUN chown -R app_user:app_user /app
USER app_user

ARG FLASK_SECRET_KEY
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION

ENV AWS_ACCESS_KEY_ID $AWS_ACCESS_KEY_ID
ENV AWS_SECRET_ACCESS_KEY $AWS_SECRET_ACCESS_KEY
ENV AWS_DEFAULT_REGION $AWS_DEFAULT_REGION
ENV FLASK_ENV=production

ADD ./requirements.txt .

RUN pip install --no-cache-dir -r ./requirements.txt --user

COPY . /app
WORKDIR /app

CMD ["gunicorn", "-b", "0.0.0.0:5000", "app:app", "--workers=5"]