## Day 1: Docker & Containers - Deep Dive with Linux Fundamentals

---

### 1. What are Containers?

**Containers** are lightweight, portable, and isolated environments to run applications.

- Think of them as **"mini virtual machines"** but sharing the **host’s OS kernel**.
- They **bundle app code + dependencies + environment** in one unit.

---

### 2. Why Containers?

| Problem Without Containers           | How Containers Help                      |
|-------------------------------------|------------------------------------------|
| “It works on my machine” issues     | Same container runs anywhere             |
| Complex dependency installations    | All dependencies are inside the container |
| Heavyweight VMs for simple apps     | Containers are lightweight (MBs vs GBs)  |
| Difficult scaling                   | Containers can be replicated easily      |
| Long boot time                      | Containers start in milliseconds         |

---

### 3. Real-World Example: Java App

Imagine:
- Dev builds a Java app using JDK 11.
- Test team uses JDK 8 — **App fails**.

With Docker:
```bash
docker run openjdk:11 java -jar myapp.jar
```
Boom! Everyone runs with JDK 11 — **no conflicts**.

---

### 4. How Docker Uses Linux Fundamentals

| Linux Concept     | Used By Docker For                  | Example                                     |
|-------------------|-------------------------------------|---------------------------------------------|
| **Namespaces**    | Process isolation                   | Each container has its own PID, NET, etc.   |
| **cgroups**       | Resource limits                     | Limit CPU, memory per container             |
| **UnionFS**       | Layered filesystems                 | Docker images use layers (e.g., aufs/overlay2) |
| **chroot**        | Isolated root filesystem            | Container root starts from `/`, but isolated |
| **Capabilities**  | Fine-grained privilege control      | Drop/enable capabilities inside containers  |

---

### 5. Install Docker (Linux)

```bash
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker
```

Test:
```bash
docker version
docker info
```

---

### 6. Docker Basics - Hands-On Commands

```bash
docker run hello-world                # Run a test container
docker images                         # List images
docker ps -a                          # List all containers
docker run -it ubuntu bash            # Run an interactive Ubuntu shell
docker exec -it <container_id> bash  # Exec into running container
docker stop <container_id>           # Stop container
docker rm <container_id>             # Remove container
docker rmi <image_id>                # Remove image
```

---

### 7. Create Your First Container App

**Example:** Run Python HTTP server in a container.

```bash
docker run -d -p 8000:8000 python:3 bash -c "cd / && python3 -m http.server"
```

Now visit: `http://localhost:8000`

---

### 8. Docker Images

**Build your own:**

`Dockerfile`:
```Dockerfile
FROM ubuntu
RUN apt update && apt install -y nginx
CMD ["nginx", "-g", "daemon off;"]
```

Build & Run:
```bash
docker build -t mynginx .
docker run -d -p 8080:80 mynginx
```

---

### 9. Homework / Live Activity Suggestions

- Run an Apache container
- Run Redis or MySQL container
- Create your own image with a simple web app

---

### 10. What’s Next

- Dockerfile detailed tutorial
- Docker volumes
- Docker networks
- Docker Compose
- CI/CD with Docker
- Docker Swarm / Kubernetes

