# RouteLLM Docker Image with BERT Routing
# No OpenAI API key needed for routing
# Build: docker build -t routellm-bert .
# Run:   docker run -p 6060:6060 --env-file .env routellm-bert

FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Install routellm with serve and eval extras
RUN pip install --no-cache-dir "routellm[serve,eval]"

# Create config directory
RUN mkdir -p /app/config

# Copy configuration file
COPY config.yaml /app/config/config.yaml

# Expose the server port
EXPOSE 6060

# Default command with bert router
# Environment variables can be passed via docker run -e
CMD python -m routellm.openai_server \
    --routers bert \
    --config /app/config/config.yaml \
    --port 6060 \
    --strong-model ${STRONG_MODEL:-ollama_chat/llama3} \
    --weak-model ${WEAK_MODEL:-ollama_chat/phi3} \
    --base-url ${API_BASE:-http://host.docker.internal:11434/v1} \
    --api-key ${API_KEY:-ollama}