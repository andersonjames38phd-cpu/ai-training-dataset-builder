// AI Training Dataset Builder — Node.js example.
//
// Install:
//   npm install apify-client
//
// Run:
//   APIFY_TOKEN=your_token node node.mjs

import { ApifyClient } from 'apify-client';

const TOKEN = process.env.APIFY_TOKEN ?? 'YOUR_TOKEN';
const ACTOR = 'Turboextract/ai-training-dataset-builder';

const client = new ApifyClient({ token: TOKEN });

// 1. Build a RAG corpus from a curated URL list
const runInput = {
    startUrls: [
        { url: 'https://blog.apify.com/web-scraping-report-2026/' },
        { url: 'https://en.wikipedia.org/wiki/Retrieval-augmented_generation' },
        { url: 'https://docs.python.org/3/tutorial/introduction.html' },
    ],
    maxPages: 100,
    minWordCount: 200,
    includeImages: false,
};

const run = await client.actor(ACTOR).call(runInput);

// 2. Pull dataset items
const { items } = await client.dataset(run.defaultDatasetId).listItems();

for (const item of items) {
    console.log(`[${String(item.wordCount).padStart(5)}w] ${item.title}`);
    console.log(`        ${item.url}`);
}

console.log(`\n${items.length} pages successfully extracted.`);

// 3. Or stream item-by-item (useful for large jobs)
// for await (const item of client.dataset(run.defaultDatasetId).iterate()) {
//     console.log(item.title);
// }
