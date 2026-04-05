FROM python:3.13.0-slim

WORKDIR /app

# Install uv
RUN pip install --no-cache-dir uv

# Copy dependency files first
COPY pyproject.toml uv.lock ./

# Install dependencies via uv
RUN uv sync --frozen

# Copy rest of code
COPY . .

EXPOSE 5000

CMD ["uv", "run", "run.py"]