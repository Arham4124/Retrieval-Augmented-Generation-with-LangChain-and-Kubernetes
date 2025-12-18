FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Create directory for documents and vector store
RUN mkdir -p /app/documents /app/chroma_db

# Copy the application files
COPY . .

# Ensure test.txt is in the documents directory
RUN if [ -f test.txt ] && [ ! -f documents/test.txt ]; then cp test.txt documents/test.txt; fi

# Pre-initialize the vector store to load documents at build time
RUN python -c "from document_store import load_documents; load_documents()"

# Expose the port the app runs on
EXPOSE 8000

# Create an entrypoint script to run initialization before starting the server
RUN echo '#!/bin/bash\nset -e\necho "Running application initialization..."\npython /app/init_app.py\necho "Starting web server..."\nexec uvicorn app:app --host 0.0.0.0 --port 8000' > /app/entrypoint.sh \
    && chmod +x /app/entrypoint.sh

# Use the entrypoint script to initialize the app and start the server
CMD ["/app/entrypoint.sh"]