# app/main.py
# Este archivo crea la app FastAPI con endpoints de health y ready.
# CORS se configura desde la variable de entorno CORS_ORIGINS (lista separada por comas).

import os

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI(title="API DevStack", version="0.1.0")

# Configuración de CORS desde variable de entorno
cors_origins = os.getenv("CORS_ORIGINS", "http://localhost").split(",")
app.add_middleware(
    CORSMiddleware,
    allow_origins=cors_origins,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allow_headers=["*"],
)


@app.get("/healthz")
def healthz():
    # Chequeo básico: la app está arriba
    return {"status": "ok"}


@app.get("/readyz")
def readyz():
    # Aquí se podría comprobar conexión a DB o migraciones
    # En dev devolvemos listo para simplificar
    return {"status": "ready"}


@app.get("/")
def root():
    return {"message": "Hola desde FastAPI!"}
