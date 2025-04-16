# Docker Networking & Volumes - In Depth Guide

## ✨ Docker Network Types Overview

| Network Type  | Description | Container-to-Container Communication | Host Access | Use Case |
|---------------|-------------|--------------------------------------|-------------|----------|
| `bridge`      | Default for standalone containers | Yes (if on same network) | Yes | Isolated app containers on a single host |
| `host`        | Shares host network stack | Yes (via host IP/ports) | Yes | Performance-critical apps or legacy tools |
| `none`        | No network connectivity | ❌ | ❌ | Fully isolated containers |
| `overlay`     | For multi-host communication via Swarm | Yes | Yes | Swarm services across multiple nodes |
| `macvlan`     | Assigns MAC address, acts like a physical device | Yes (as separate host on LAN) | Yes | Needs real LAN IP, advanced networking |

---

## 🔧 1. `bridge` Network (Default)

### 📌 Used when you run: `docker run` without specifying network.

```bash
docker network create my-bridge-net
docker run -dit --name container1 --network my-bridge-net alpine sh
docker run -dit --name container2 --network my-bridge-net alpine sh
docker exec container1 ping container2
```

✅ **They can ping each other by name** because they're on the same custom bridge.

---

## 🚀 2. `host` Network

### 📌 Container shares the host’s network stack. No isolation.

```bash
docker run -d --network host nginx
```

- NGINX runs on host’s ports (e.g., `http://localhost:80`)
- No `docker inspect` IP; uses host IP directly

✅ **High performance** (no network namespace)  
⚠️ **No port mapping possible (`-p` ignored)**

---

## 🧱 3. `none` Network

### 📌 No network interfaces except loopback (isolated container)

```bash
docker run -dit --network none alpine
```

- No internet
- Cannot ping other containers or host

✅ Good for **sandboxing or security-focused containers**

---

## 🌐 4. `overlay` Network (Swarm Mode Only)

### 📌 Enables containers on different hosts to communicate securely.

```bash
docker swarm init
docker network create -d overlay my-overlay
docker service create --name web --replicas 2 --network my-overlay nginx
```

✅ Best for **multi-host setups** (e.g., in Swarm clusters)  
⚠️ Not available for standalone containers unless in Swarm

---

## 📡 5. `macvlan` Network

### 📌 Assigns a unique MAC & IP from LAN to container. Looks like a separate device.

```bash
docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.1 \
  -o parent=eth0 pub_net

docker run -dit --network pub_net --name macvlan-container alpine
```

- Container can be accessed directly from LAN
- IP assigned by you or DHCP

✅ Used in **advanced networking, IoT devices, legacy systems**  
⚠️ Needs advanced setup, not suitable for all cases

---

## 🧠 TL;DR - When to Use What?

| Network Type | When to Use |
|--------------|-------------|
| `bridge`     | Default for most single-host apps |
| `host`       | When performance is key, or you want access to host's network |
| `none`       | For fully isolated containers |
| `overlay`    | For container-to-container across nodes (Swarm) |
| `macvlan`    | When container needs to be on same LAN as host, with its own IP |

---

# Why Two Containers on Default Bridge Can't Talk to Each Other

## ❗️ Default bridge has limitations

```bash
docker run -dit --name app1 alpine
docker run -dit --name app2 alpine
```

```bash
docker exec -it app1 ping app2  # ❌ fails
```

### 🔎 Reason:
- Default `bridge` network **does not provide DNS resolution**
- Containers can't resolve each other by name
- Only accessible by dynamic IP (not practical)

---

## ✅ How to Make Them Communicate Properly

Use a **custom bridge network**:

```bash
docker network create my-net
docker run -dit --name app1 --network my-net alpine
docker run -dit --name app2 --network my-net alpine
docker exec -it app1 ping app2  # ✅ works!
```

## ⚙️ Comparison: Default vs Custom Bridge

| Feature                        | Default `bridge` | Custom bridge |
|-------------------------------|------------------|---------------|
| Name resolution (DNS)         | ❌ No             | ✅ Yes        |
| Container name as hostname    | ❌ No             | ✅ Yes        |
| Better isolation control      | ❌ Limited        | ✅ Yes        |
| Can reference by service name | ❌ No             | ✅ Yes        |

---

# 📁 Docker Volumes & Bind Mounts

## 📃 Difference Between Docker Volumes and Bind Mounts

| Feature               | Volume                             | Bind Mount                            |
|----------------------|------------------------------------|---------------------------------------|
| Managed by Docker    | ✅ Yes                              | ❌ No                                  |
| Host file system path| Abstracted (`/var/lib/docker/...`) | Specified manually                    |
| Backups & migration  | Easier (Docker CLI supports it)    | Harder                                |
| Permission handling  | Docker manages                     | Up to host user                       |
| Use case             | Prod, easier portability           | Dev environment, share code live      |

---

## ✍️ Examples

### Docker Volume Example

```bash
docker volume create mydata
docker run -d --name vol-nginx -v mydata:/usr/share/nginx/html nginx
```

✅ Good for persisting app data, logs, or DB storage.

### Bind Mount Example

```bash
docker run -d --name bind-nginx -v $(pwd)/html:/usr/share/nginx/html nginx
```

✅ Good for **live development** (e.g., HTML/JS updates without rebuild).

---

## 🚀 Use Case: Docker Volume in Angular App on ECS

In ECS with Dockerized Angular:

- Angular app is static files built via `ng build`
- Final files are served via nginx or Apache inside container

### Use Case
- Volume can be used for sharing logs
- Mounting EFS (Elastic File System) as a volume in ECS to store **build artifacts**

```json
{
  "mountPoints": [
    {
      "sourceVolume": "efs-angular-build",
      "containerPath": "/usr/share/nginx/html",
      "readOnly": true
    }
  ]
}
```

✅ Use for scalable, persistent, shared storage across ECS tasks.

---

Let me know if you want this exported to PDF or need visuals added!

