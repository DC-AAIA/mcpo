FROM python:3.12-slim-bookworm

# Install uv (from official binary), nodejs, npm, and git
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm via NodeSource 
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Confirm npm and node versions (optional debugging info)
RUN node -v && npm -v

# Copy your mcpo source code
COPY . /app
WORKDIR /app

# Create virtual environment explicitly in known location
ENV VIRTUAL_ENV=/app/.venv
RUN uv venv "$VIRTUAL_ENV"
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install mcpo
RUN uv pip install . && rm -rf ~/.cache

# Install a default MCP server (filesystem as example)
RUN npm install -g @modelcontextprotocol/server-filesystem

# Verify installations
RUN which mcpo
RUN which mcp-server-filesystem

# IMPORTANT: Remove ENTRYPOINT and use a proper CMD
# This allows Railway to override with custom start command if needed
CMD ["mcpo", "--host", "0.0.0.0", "--port", "8000", "--", "mcp-server-filesystem", "/app"]
