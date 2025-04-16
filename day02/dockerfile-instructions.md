# Dockerfile: All Instructions Explained with Use Cases and Examples

## 🧱 What is a Docker Layer?

A **layer** is an intermediate image created by each instruction in a Dockerfile. Docker caches these layers to speed up rebuilds.

### Instructions that Create Layers:
- `FROM`
- `COPY`
- `ADD`
- `RUN`
- `CMD`
- `ENTRYPOINT`
- `ENV`
- `LABEL`
- `WORKDIR`
- `USER`
- `EXPOSE`
- `VOLUME`

Instructions like `ARG` and `HEALTHCHECK` **do not create** layers.

---

## 🔥 ENTRYPOINT vs CMD

| Aspect        | `ENTRYPOINT`                          | `CMD`                          |
|---------------|----------------------------------------|--------------------------------|
| Purpose       | Defines **what to run**                | Defines **default arguments** |
| Override-able | **No**, unless `--entrypoint` used     | ✅ Easily overridden via CLI   |
| Typical use   | Required command (e.g., app binary)    | Optional/default params        |

### ENTRYPOINT + CMD Example:
```dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY app.py .
ENTRYPOINT ["python", "app.py"]
CMD ["--help"]
```

### app.py:
```python
import sys

def main():
    if len(sys.argv) < 2:
        print("No arguments passed. Use --help for options.")
        return

    arg = sys.argv[1]

    if arg == '--help':
        print("Usage:")
        print("  --help     Show this message")
        print("  --run      Run the app")
        print("  --version  Show version info")
    elif arg == '--run':
        print("✅ Running the app logic!")
    elif arg == '--version':
        print("App version: 1.0.0")
    else:
        print(f"Unknown argument: {arg}. Use --help for available options.")

if __name__ == "__main__":
    main()
```

### Build and Run:
```bash
docker build -t my-python-app .
docker run my-python-app            # Shows help
docker run my-python-app --run      # Runs logic
docker run --entrypoint=python my-python-app -V  # Shows python version
```

---

## 📦 COPY vs ADD

| Instruction | Feature                        | Notes                                   |
|-------------|----------------------------------|-----------------------------------------|
| `COPY`      | Basic file copy                 | Recommended for most use cases          |
| `ADD`       | Supports URLs & auto-unpacking | Use only when you need those features   |

### Example:
```dockerfile
COPY . /app
ADD https://example.com/file.tar.gz /app/
```

---

## 🏃 RUN vs CMD

| Instruction | Purpose                          | Executes During       |
|-------------|----------------------------------|------------------------|
| `RUN`       | Build time script execution      | Image build phase      |
| `CMD`       | Default runtime command/params   | Container run phase    |

### Example:
```dockerfile
RUN apt update && apt install -y curl
CMD ["python", "script.py"]
```

---

## 🐚 SHELL vs EXEC Form

| Form       | Syntax                              | Shell Used       |
|------------|--------------------------------------|------------------|
| Shell      | `RUN apt update && apt install`     | `/bin/sh -c`     |
| Exec       | `RUN ["apt", "install", "-y"]`       | Direct execution |

### SHELL:
```dockerfile
RUN echo $HOME
```

### EXEC:
```dockerfile
RUN ["echo", "$HOME"]  # This will not work as expected!
```

Use **SHELL** when you need shell features like variable expansion or chaining.

---

## 🧪 Real-World ENTRYPOINT + CMD Python App Example

### Dockerfile
```dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY app.py .
ENTRYPOINT ["python", "app.py"]
CMD ["--help"]
```

### app.py
```python
import sys

def main():
    if len(sys.argv) < 2:
        print("No arguments passed. Use --help for options.")
        return

    arg = sys.argv[1]

    if arg == '--help':
        print("Usage:")
        print("  --help     Show this message")
        print("  --run      Run the app")
        print("  --version  Show version info")
    elif arg == '--run':
        print("✅ Running the app logic!")
    elif arg == '--version':
        print("App version: 1.0.0")
    else:
        print(f"Unknown argument: {arg}. Use --help for available options.")

if __name__ == "__main__":
    main()
```

---

## 💡 Other Dockerfile Instructions with Use Cases

| Instruction  | Use Case/Example |
|--------------|------------------|
| `FROM`       | Base image to build upon: `FROM ubuntu:22.04` |
| `LABEL`      | Metadata about the image: `LABEL maintainer="dev@example.com"` |
| `ENV`        | Environment variable: `ENV NODE_ENV=production` |
| `WORKDIR`    | Set working directory: `WORKDIR /app` |
| `USER`       | Specify user to run as: `USER appuser` |
| `VOLUME`     | Declare mount point: `VOLUME /data` |
| `EXPOSE`     | Document ports the app uses: `EXPOSE 80` |
| `ARG`        | Build-time variables: `ARG NODE_VER=18` |
| `HEALTHCHECK`| Add health checks to containers |

---

## 📚 Summary

Dockerfiles are recipes for building container images. Choosing between `RUN`, `CMD`, and `ENTRYPOINT` depends on when and how you want commands to run. Combining `ENTRYPOINT` + `CMD` allows flexible yet controlled container behavior.



