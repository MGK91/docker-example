
# 🚀 Production-Ready Dockerfile with Node.js 22 — Best Practices Guide

This guide teaches how to write an optimized, secure, and production-ready Dockerfile using Node.js 22 and a simple Express app.

---

## 📦 Sample App Structure

```
sample-app/
├── Dockerfile
├── package.json
├── package-lock.json
└── index.js
```

---

## 🧑‍💻 Sample `package.json`

```json
{
  "name": "sample-app",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```

---

## 🧑‍💻 Sample `index.js`

```js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Hello from Node 22!');
});

app.listen(3000, () => {
  console.log('App running on port 3000');
});
```

---

## 🛠️ Dockerfile (Optimized for Node.js 22)

```Dockerfile
# Stage 1: Build the app with dependencies
FROM node:22-slim AS builder

# Create app directory
WORKDIR /app

# Install dependencies early for better layer caching
COPY package*.json ./
RUN npm ci --only=production

# Copy rest of the application
COPY . .

# Stage 2: Minimal runtime environment
FROM node:22-alpine

# Create non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy built app and deps from builder stage
COPY --from=builder /app /app

# Use non-root user for safety
USER appuser

# Expose application port
EXPOSE 3000

# Optional: Healthcheck
# HEALTHCHECK --interval=30s --timeout=10s CMD wget -qO- http://localhost:3000/ || exit 1

# Start the app
CMD ["node", "index.js"]
```

---

## ✅ Best Practices Covered

| Practice                         | Description |
|----------------------------------|-------------|
| Multi-stage builds               | Keep final image lean by separating build & runtime |
| Minimal base image (`alpine`)    | Smaller, faster, fewer vulnerabilities |
| Layer caching                    | Install dependencies first, copy code later |
| `npm ci --only=production`       | Fast and consistent install, avoids dev deps |
| Non-root user                    | Avoids running as root for security |
| Healthcheck (optional)           | Docker monitors container health |
| Clean, small image (~70MB)       | Compared to ~950MB unoptimized |

---

## 🔧 Build & Run the App

```bash
# Build Docker image
docker build -t node22-prod-app .

# Run the app
docker run -p 3000:3000 node22-prod-app
```

Access your app at: [http://localhost:3000](http://localhost:3000)

You should see:
```
Hello from Node 22!
```

---

## 🔐 Extra: Docker Security Scan

Scan your image for vulnerabilities (optional):
```bash
docker scan node22-prod-app
```

---

## 🎓  Tips

- Explain `COPY package*.json` before full source for caching
- Show size difference using `docker image ls`
- Emphasize non-root security model
- Compare to naive Dockerfiles (1 stage, no user, full base)
- Use `docker history` to explain layer creation

---

Happy Dockering! 🐳✨
