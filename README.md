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
| `STRONG_MODEL_API_KEY` | API key for strong model | `ollama` |
| `WEAK_MODEL_API_KEY` | API key for weak model | `ollama` |
| `STRONG_MODEL_API_BASE` | Endpoint for strong model | `http://host.docker.internal:11434/v1` |
| `WEAK_MODEL_API_BASE` | Endpoint for weak model | `http://host.docker.internal:11434/v1` |

### Using External Providers (Optional)

Instead of Ollama, use OpenAI, Anthropic, Together, etc.:

```bash
# OpenAI example
STRONG_MODEL=gpt-4o
STRONG_MODEL_API_KEY=sk-your-key
STRONG_MODEL_API_BASE=https://api.openai.com/v1

WEAK_MODEL=gpt-4o-mini
WEAK_MODEL_API_KEY=sk-your-key
WEAK_MODEL_API_BASE=https://api.openai.com/v1

# Or Anthropic
STRONG_MODEL=claude-3-opus-20240229
STRONG_MODEL_API_KEY=sk-ant-
STRONG_MODEL_API_BASE=https://api.anthropic.com/v1
```

## Model Name Format

Use: `router-[ROUTER]-[THRESHOLD]`

- `router-bert-0.3` - 30% to strong model, 70% to weak
- `router-bert-0.5` - 50/50 split
- `router-bert-0.7` - 70% to strong model, 30% to weak

## Available Routers

Change the router in Dockerfile CMD if needed:
- `bert` - BERT classifier (default, no OpenAI key needed)
- `mf` - Matrix factorization (needs embeddings)
- `sw_ranking` - Weighted Elo (needs embeddings)
- `random` - Random routing

## Build

```bash
docker build -t routellm-bert .
```

## License

Apache 2.0 - See [RouteLLM](https://github.com/lm-sys/RouteLLM)