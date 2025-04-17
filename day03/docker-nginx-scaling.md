
# 🚀 Docker Compose App Scaling with NGINX Reverse Proxy

This guide shows how to scale a Node.js app using Docker Compose and load balance it using NGINX.

---

## 🧱 Folder Structure

```
.
├── Dockerfile
├── docker-compose.yml
├── nginx.conf
├── app.js
└── docker-nginx-scaling.md
```

---

## 📦 Dockerfile

```Dockerfile
# Use Node base image
FROM node:18

# Create app directory
WORKDIR /app

# Copy and install dependencies
COPY package*.json ./
RUN npm install

# Copy source files
COPY . .

# Expose internal port
EXPOSE 3000

# Start the app
CMD ["node", "app.js"]
```

---

## 🛠 Sample `app.js`

```js
const express = require('express');
const app = express();
const PORT = 3000;

app.get('/', (req, res) => {
  res.send(\`Hello from \${process.env.HOSTNAME || 'app'}!\`);
});

app.listen(PORT, () => {
  console.log(\`App running on port \${PORT}\`);
});
```

---

## 📄 docker-compose.yml

```yaml
version: "3.8"

services:
  app:
    build: .
    expose:
      - "3000"
    networks:
      - app_net

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - app
    networks:
      - app_net

networks:
  app_net:
```

---

## 🌐 nginx.conf

```nginx
events {}

http {
    upstream app_servers {
        server app:3000;
        # Docker Compose DNS will resolve all scaled app containers
    }

    server {
        listen 80;

        location / {
            proxy_pass http://app_servers;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
        }
    }
}
```

---

## 🚀 Running Everything

### 1. Build and start the containers (scaling app to 3 instances)

```bash
docker-compose up --build --scale app=3
```

### 2. Open in browser

Go to: [http://localhost](http://localhost)  
Each refresh should hit a different app container (round-robin via NGINX).

---

## ✅ Tips

- Don't use `ports: "3000:3000"` in the app — only `expose` it inside the Docker network.
- `server app:3000;` in NGINX is enough — Docker’s DNS resolves all instances of `app`.
- Use `nginx:alpine` for a lightweight reverse proxy image.

---

## 🧠 Optional Enhancements

- 🔄 Add `nodemon` for live reload in dev
- 🔒 Add SSL support (Certbot or self-signed)
- ❤️ Add sticky sessions if needed
- 🔍 Add health checks

---

Made with ☕ by [Your Name]
