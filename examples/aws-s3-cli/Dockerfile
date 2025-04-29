FROM debian:bookworm-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    curl \
    unzip \
    jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# Create directory for scripts
RUN mkdir -p /app/scripts

# Copy the scripts
COPY start.sh /app/scripts/
COPY stop.sh /app/scripts/

# Make scripts executable
RUN chmod +x /app/scripts/*.sh

# Set working directory
WORKDIR /app/scripts

# Add scripts to PATH
ENV PATH="/app/scripts:${PATH}"

# Default command
CMD ["bash"]