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

using unshare command to mimic docker run -it command line , unshare command runs in a isloated environment (Linux namespaces)

mkdir ~/alpine-rootfs && cd ~/alpine-rootfs
curl -LO https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/x86_64/alpine-minirootfs-3.18.4-x86_64.tar.gz
sudo tar -xzf alpine-minirootfs-3.18.4-x86_64.tar.gz

The above mimics docker pull 

now 
sudo unshare --fork --pid --mount --uts --ipc --net --user --map-root-user chroot ./ /bin/sh

Above command runs alpine in a container like environment

docker run -it alpine #Simialr to this command


Docker resources and Cgroups 

Run a container ubuntu with --restart always argument making sure the container is always running even if the host machine is restarted 

docker run -itd --restart always --name ubuntu-local ubuntu

Now get the PID of the container 

docker inspect --format '{{.State.Pid}}' ubuntu-local

cat /proc/<pid>/cgroup


[root@ip-x-x-x-x ~]# docker inspect --format '{{.State.Pid}}' ubuntu-local
2746
[root@ip-x-x-x-x ~]# cat /proc/2746/cgroup
0::/system.slice/docker-96ad67517caf60b6a8625e9cf65ea8b73e0136b543ed8c4ea94b616b2aad3c1f.scope

Now look at various config related to cpu , cpuset, memory , io etc under the path mentioned like below 

[root@ip-x-x-x-x ~]# cat /sys/fs/cgroup/system.slice/docker-96ad67517caf60b6a8625e9cf65ea8b73e0136b543ed8c4ea94b616b2aad3c1f.scope/cpu.stat
usage_usec 31849
user_usec 31849
system_usec 0
core_sched.force_idle_usec 0
nr_periods 0
nr_throttled 0
throttled_usec 0
nr_bursts 0
burst_usec 0

---

Linux containers 

https://blog.purestorage.com/purely-educational/lxc-vs-lxd-linux-containers-demystified/

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

