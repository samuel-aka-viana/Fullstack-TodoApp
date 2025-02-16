import os
from datetime import timedelta
from dotenv import load_dotenv
from hypercorn.config import Config as HyperConfig

load_dotenv()

class Config:
    SQLALCHEMY_DATABASE_URI = os.getenv('SQLALCHEMY_DATABASE_URI')
    SQLALCHEMY_TRACK_MODIFICATIONS = False

    JWT_TOKEN_LOCATION = ["headers"]
    JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY')
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(minutes=15)
    JWT_REFRESG_TOKEN_EXPIRES = timedelta(days=30)

def create_hypercorn_config():
    config = HyperConfig()
    config.bind = ["0.0.0.0:5000"]
    config.workers = 4
    config.accesslog = "-"
    config.errorlog = "-"
    config.worker_class = "asyncio"
    config.keepalive_timeout = 75
    return config

hypercorn_config = create_hypercorn_config()