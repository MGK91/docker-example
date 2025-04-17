# Docker ARG Build Example

This example shows how to use `ARG` in a Dockerfile to define and use build-time variables.

---

## 🐳 Dockerfile Example

```Dockerfile
# Use a base image
FROM ubuntu:22.04

# Define an argument with a default value
ARG USERNAME=guest

# Set environment variable using the argument
ENV USER=$USERNAME

# Create a new user from the ARG
RUN useradd -m $USER

# Set working directory to the user's home
WORKDIR /home/$USER

# Output the user info
CMD echo "Container running as user: $USER"
```

---

## 🔧 Build Command

To build the Docker image with a custom username:

```bash
docker build --build-arg USERNAME=devuser -t custom-user-image .
```

Without `--build-arg`, it will default to `guest`.

---

## 🚀 Run the Container

```bash
docker run --rm custom-user-image
```

Expected output:

```
Container running as user: devuser
```

---

## ✅ Summary

- `ARG` is used at **build-time** only.
- `ENV` can persist into the **container runtime**.
- Use `--build-arg` with `docker build` to pass values.
