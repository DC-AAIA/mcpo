FROM node:20-slim

# Install Python and pip for MCPO
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv

# Create virtual environment and install MCPO
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install mcpo

# Install n8n-mcp globally via npm
RUN npm install -g @czlonkowski/n8n-mcp

# Set working directory
WORKDIR /app

# Set the command to run MCPO with n8n-mcp in stdio mode
CMD ["mcpo", "--host", "0.0.0.0", "--port", "8000", "--", "npx", "@czlonkowski/n8n-mcp"]
