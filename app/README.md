# Step 3: Prepare Application (Docker)

This directory contains the source code and Dockerfile to build our sample application.

## Execution Steps

### Build Blue Version (v1)

1. Make sure `index.html` contains:
   ```html
   <h1>Blue Version</h1>
   ```

2. Build and push the image to DockerHub (replace `<dockerhub-username>` with your actual username):
   ```bash
   docker build -t <dockerhub-username>/myapp:v1 .
   docker push <dockerhub-username>/myapp:v1
   ```

### Build Green Version (v2)

1. Modify the `index.html` file to say:
   ```html
   <h1>Green Version</h1>
   ```

2. Build and push the updated image:
   ```bash
   docker build -t <dockerhub-username>/myapp:v2 .
   docker push <dockerhub-username>/myapp:v2
   ```
