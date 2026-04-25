# RouteLLM Docker - BERT Router

Docker image for [RouteLLM](https://github.com/lm-sys/RouteLLM) with BERT routing.

## Why BERT Router?

- **No OpenAI API key required for routing** - BERT classifier runs locally
- Uses text classification, not embeddings
- Routes simpler queries to cheaper models, saving up to 85% costs

## Quick Start

### Prerequisites

1. Ollama running locally (or use any model provider)
   ```bash
   ollama pull llama3
   ollama pull phi3
   ```

### Run

```bash
# Copy and edit env
cp .env.example .env

# Build and run
docker-compose up --build
```

Server starts at `http://localhost:6060`

### Test

```bash
curl -X POST http://localhost:6060/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "router-bert-0.5",
    "messages": [{"role": "user", "content": "What is 2+2?"}]
  }'
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `STRONG_MODEL` | Model for complex queries | `ollama_chat/llama3` |
| `WEAK_MODEL` | Model for simple queries | `ollama_chat/phi3` |
| `API_BASE` | API endpoint for models | `http://host.docker.internal:11434/v1` |
| `API_KEY` | API key for models | `ollama` |
| `OPENAI_API_KEY` | Required by litellm (dummy OK) | `nokey` |

### Using External Providers

Instead of Ollama, use OpenAI, Anthropic, Together, etc.:

```bash
# OpenAI example
STRONG_MODEL=gpt-4o
WEAK_MODEL=gpt-4o-mini
API_BASE=https://api.openai.com/v1
API_KEY=sk-your-key
```

## Model Name Format

Use: `router-[ROUTER]-[THRESHOLD]`

- `router-bert-0.3` - Low threshold → easier to route to **strong** model → more strong model calls
- `router-bert-0.5` - Medium threshold → balanced
- `router-bert-0.7` - High threshold → harder to route to strong → more **weak** model calls (cheaper)

## Caching

The `./cache` directory caches the BERT model between runs. On first build, it downloads ~400MB. Subsequent runs reuse the cache.

To clear cache: `rm -rf ./cache`

Or mount a custom volume if needed:
```yaml
volumes:
  - my-cache:/root/.cache
```

## Build

```bash
docker build -t routellm-bert .
```

## License

Apache 2.0 - See [RouteLLM](https://github.com/lm-sys/RouteLLM)