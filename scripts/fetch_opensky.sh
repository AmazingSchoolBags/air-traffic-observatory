#!/bin/sh

echo "Démarrage du fetcher OpenSky..."
echo "API: $OPENSKY_API_URL"
echo "Webhook n8n: $N8N_WEBHOOK_URL"
echo "Intervalle: $FETCH_INTERVAL secondes"

while true
do
  echo "Appel OpenSky à $(date -Iseconds)"

  curl -s "$OPENSKY_API_URL" -o /tmp/opensky_response.json

  if [ ! -s /tmp/opensky_response.json ]; then
    echo "Réponse vide depuis OpenSky"
  else
    curl -s -X POST "$N8N_WEBHOOK_URL" \
      -H "Content-Type: application/json" \
      --data-binary @/tmp/opensky_response.json

    echo ""
    echo "Payload envoyé à n8n"
  fi

  sleep "$FETCH_INTERVAL"
done
