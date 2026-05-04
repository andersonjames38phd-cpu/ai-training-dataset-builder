#!/usr/bin/env bash
# AI Training Dataset Builder — curl examples
# Replace YOUR_TOKEN with an Apify API token (https://console.apify.com/account/integrations).

set -euo pipefail

ACTOR="Turboextract~ai-training-dataset-builder"
TOKEN="${APIFY_TOKEN:-YOUR_TOKEN}"

# 1. Single URL — quick smoke test
curl -sS -X POST "https://api.apify.com/v2/acts/${ACTOR}/runs?token=${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "startUrls": [
      { "url": "https://en.wikipedia.org/wiki/Retrieval-augmented_generation" }
    ],
    "maxPages": 1,
    "minWordCount": 50
  }'

# 2. Mixed URL list — typical RAG-corpus seeding
curl -sS -X POST "https://api.apify.com/v2/acts/${ACTOR}/runs?token=${TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "startUrls": [
      { "url": "https://blog.apify.com/web-scraping-report-2026/" },
      { "url": "https://docs.python.org/3/tutorial/introduction.html" },
      { "url": "https://en.wikipedia.org/wiki/Retrieval-augmented_generation" }
    ],
    "maxPages": 100,
    "minWordCount": 200,
    "includeImages": false
  }'

# 3. Synchronous run — get items in the same response (small jobs only)
curl -sS -X POST "https://api.apify.com/v2/acts/${ACTOR}/run-sync-get-dataset-items?token=${TOKEN}&format=json" \
  -H "Content-Type: application/json" \
  -d '{
    "startUrls": [
      { "url": "https://en.wikipedia.org/wiki/Large_language_model" }
    ],
    "maxPages": 1,
    "minWordCount": 50
  }'
