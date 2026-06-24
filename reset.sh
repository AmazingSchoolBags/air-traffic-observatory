#!/bin/bash

echo "Suppression de l'environnement Air Traffic..."
docker compose down -v

echo "Relance de l'environnement..."
docker compose up -d

echo "État des services :"
docker compose ps
