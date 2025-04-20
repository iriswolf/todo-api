from typing import Literal

from pydantic import PostgresDsn
from pydantic_settings import BaseSettings, SettingsConfigDict

from .types.enums import EnvironmentEnum


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

    app_name: str = "Todo API"
    env: EnvironmentEnum = EnvironmentEnum.dev

    postgres_dsn: PostgresDsn

    jwt_secret_key: str = "secret_key"
    jwt_algorithm: str = "HS256"
    access_token_expire_minutes: int = 15

    @property
    def debug(self) -> bool:
        return self.env == EnvironmentEnum.dev


settings = Settings()
