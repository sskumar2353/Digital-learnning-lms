"""AI API entry: CORS, .env, and chatbot + recommendations routers."""
from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

try:
    from dotenv import load_dotenv
    load_dotenv(Path(__file__).resolve().parent / ".env")
except ImportError:
    pass

# Load shared embedding model first (used by both chatbot and recommendations)
import shared_embeddings  # noqa: F401

from chatbot import router as chatbot_router
from recommendations import router as recommendations_router

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(chatbot_router)
app.include_router(recommendations_router)


@app.get("/health")
def health():
    return {"ok": True}
