# Dockerfile: ENTRYPOINT vs CMD with Examples

## 🔥 Quick Difference: `ENTRYPOINT` vs `CMD`

| Aspect        | `ENTRYPOINT`                          | `CMD`                          |
|---------------|----------------------------------------|--------------------------------|
| Purpose       | Defines **what to run**                | Defines **default arguments** |
| Override-able | **No**, unless `--entrypoint` used     | ✅ Easily overridden via CLI   |
| Typical use   | Required command (e.g., app binary)    | Optional/default params        |

---

## ✅ Example 1: Using `CMD` Only

```dockerfile
# Dockerfile
FROM ubuntu:22.04
CMD ["echo", "Hello from CMD"]
```

### Build and Run:
```bash
docker build -t cmd-example .
docker run cmd-example
```

**Output:**
```
Hello from CMD
```

**Override CMD:**
```bash
docker run cmd-example echo "Override successful"
```

**Output:**
```
Override successful
```

---

## ✅ Example 2: Using `ENTRYPOINT` Only

```dockerfile
# Dockerfile
FROM ubuntu:22.04
ENTRYPOINT ["echo"]
```

### Build and Run:
```bash
docker build -t entrypoint-example .
docker run entrypoint-example "Hello from ENTRYPOINT"
```

**Output:**
```
Hello from ENTRYPOINT
```

**Override ENTRYPOINT:**
```bash
docker run --entrypoint=ls entrypoint-example -l
```

---

## ✅ Example 3: ENTRYPOINT + CMD (Best Practice)

```dockerfile
# Dockerfile
FROM ubuntu:22.04
ENTRYPOINT ["echo"]
CMD ["Default from CMD"]
```

### Build and Run:
```bash
docker build -t combo-example .
docker run combo-example
```

**Output:**
```
Default from CMD
```

**Override CMD:**
```bash
docker run combo-example "Custom message"
```

**Output:**
```
Custom message
```

**Override both:**
```bash
docker run --entrypoint=ls combo-example -l
```

---

## 🧠 When to Use What?

| Use Case                                 | Instruction       |
|------------------------------------------|-------------------|
| Main binary that **should not be replaced** | `ENTRYPOINT`       |
| Provide **default args** for the binary     | `CMD`              |
| Make both the command and args optional     | Use only `CMD`     |

---

## 🧪 Real-World Example: Python App

### `Dockerfile`
```dockerfile
FROM python:3.10-slim
WORKDIR /app
COPY app.py .

ENTRYPOINT ["python", "app.py"]
CMD ["--help"]
```

### `app.py`
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

### Build the Image:
```bash
docker build -t my-python-app .
```

### Run Examples:

```bash
# Uses CMD default
docker run my-python-app

# Overrides CMD
docker run my-python-app --run

# Overrides both ENTRYPOINT and CMD
docker run --entrypoint=python my-python-app -V
```

**Outputs:**
- `--help`: shows usage
- `--run`: runs main logic
- `-V`: shows Python version

