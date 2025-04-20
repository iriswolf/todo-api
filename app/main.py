from contextlib import asynccontextmanager

from fastapi import FastAPI

from app.core.settings import settings
from app.core.container import Container
from app.interface.rest.api_router import api_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    yield

def create_app() -> FastAPI:
    container = Container()
    container.config.from_pydantic(settings)

    app = FastAPI(
        title=settings.app_name,
        debug=settings.debug,
        lifespan=lifespan,
    )
    app.container = container  # type: ignore
    app.include_router(api_router)

    return app

app = create_app()
