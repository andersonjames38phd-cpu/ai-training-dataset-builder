"""AI Training Dataset Builder — Python example.

Install:
    pip install apify-client

Run:
    APIFY_TOKEN=your_token python python.py
"""

import os
from apify_client import ApifyClient

TOKEN = os.environ.get("APIFY_TOKEN", "YOUR_TOKEN")
ACTOR = "Turboextract/ai-training-dataset-builder"

client = ApifyClient(TOKEN)

# 1. Build a small RAG corpus from a curated URL list
run_input = {
    "startUrls": [
        {"url": "https://blog.apify.com/web-scraping-report-2026/"},
        {"url": "https://en.wikipedia.org/wiki/Retrieval-augmented_generation"},
        {"url": "https://docs.python.org/3/tutorial/introduction.html"},
    ],
    "maxPages": 100,
    "minWordCount": 200,
    "includeImages": False,
}

run = client.actor(ACTOR).call(run_input=run_input)

# 2. Stream results
for item in client.dataset(run["defaultDatasetId"]).iterate_items():
    print(f"[{item['wordCount']:>5}w] {item['title']}")
    print(f"        {item['url']}")

# 3. Or pull all at once into a list
items = list(client.dataset(run["defaultDatasetId"]).iterate_items())
print(f"\n{len(items)} pages successfully extracted.")

# 4. Hand the cleaned text straight to a vector store
# from langchain.docstore.document import Document
# docs = [Document(page_content=i["text"], metadata={"url": i["url"], "title": i["title"]}) for i in items]
