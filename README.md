# LangChain RAG Application

This is a LangChain-based Retrieval Augmented Generation (RAG) application that can answer questions based on the documents you provide.

## Prerequisites

- Docker
- Kubernetes (minikube, kind, or any Kubernetes cluster)
- OpenAI API key

## Setup Instructions

### 1. Update your OpenAI API Key

First, update the `secret.yaml` file with your actual OpenAI API key:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: langchain-secrets
type: Opaque
stringData:
  OPENAI_API_KEY: "your-openai-api-key-here"  # Replace with your actual API key
```

### 2. Build the Docker Image

```bash
docker build -t langchain-app:latest .
```

### 3. Deploy to Kubernetes

Apply the Kubernetes manifests:

```bash
kubectl apply -f persistent-volumes.yaml
kubectl apply -f secret.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

### 4. Access the Application

By default, the application is deployed with a ClusterIP service. To access it, you can:

1. Port forward the service:
   ```bash
   kubectl port-forward svc/langchain-app 8080:80
   ```

2. Then access the application at: http://localhost:8080

### 5. Using the Application

The application provides the following endpoints:

- **GET /**: Check if the application is running
- **GET /health**: Health check endpoint
- **GET /generate/{query}**: Generate responses without RAG
- **GET /rag-query/{query}**: Generate responses with RAG
- **POST /upload-document**: Upload new documents

Example usage:

1. Query about melatonin for cancer patients:
   ```
   curl http://localhost:8080/rag-query/What%20are%20the%20risks%20of%20melatonin%20for%20cancer%20patients
   ```

## File Structure

- `app.py`: FastAPI application with API endpoints
- `document_store.py`: Document loading and vector store management
- `Dockerfile`: Container definition
- `deployment.yaml`: Kubernetes deployment
- `service.yaml`: Kubernetes service
- `persistent-volumes.yaml`: PVC definitions for documents and vector DB
- `secret.yaml`: Secret for OpenAI API key
- `requirements.txt`: Python dependencies

## Troubleshooting

- If you encounter issues with document loading, check the logs with:
  ```bash
  kubectl logs deployment/langchain-app
  ```

- Make sure your OpenAI API key is valid and has sufficient credits
