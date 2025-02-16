from app import create_app
from hypercorn.asyncio import serve
import asyncio
from config import hypercorn_config

app = create_app()

async def main():
    await serve(app, hypercorn_config)

if __name__ == "__main__":
    asyncio.run(main())