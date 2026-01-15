# Install Docker to Launch LMS

Docker is required to run the LMS locally. Here's how to install it:

## macOS Installation

### Option 1: Download Docker Desktop (Recommended)

1. **Download Docker Desktop**:
   - Visit: https://www.docker.com/products/docker-desktop/
   - Click "Download for Mac"
   - Choose the version for your Mac (Intel or Apple Silicon)

2. **Install**:
   - Open the downloaded `.dmg` file
   - Drag Docker to Applications folder
   - Open Docker from Applications
   - Follow the setup wizard
   - Docker will start automatically

3. **Verify Installation**:
   ```bash
   docker --version
   docker compose version
   ```

### Option 2: Using Homebrew

```bash
brew install --cask docker
```

Then open Docker Desktop from Applications.

## After Installing Docker

1. **Make sure Docker Desktop is running**:
   - Look for the Docker icon in your menu bar
   - It should show "Docker Desktop is running"

2. **Run the launch script**:
   ```bash
   cd "/Users/aniksahai/Desktop/Ethics Lab Learning Software/lms"
   ./LAUNCH.sh
   ```

   Or manually:
   ```bash
   cd lms/docker
   docker compose up -d
   ```

3. **Access the LMS**:
   - Open: http://localhost:8000
   - Complete the setup wizard
   - Install the LMS app

## Troubleshooting

### Docker Desktop won't start
- Make sure you have enough disk space (at least 4GB free)
- Check System Preferences → Security & Privacy for any blocked permissions
- Restart your Mac and try again

### Port 8000 already in use
- Stop other services using port 8000
- Or change the port in `docker/docker-compose.yml`:
  ```yaml
  ports:
    - 8080:8000  # Use 8080 instead
  ```

### Containers won't start
- Check Docker Desktop is running
- Check system resources (CPU, memory)
- View logs: `cd docker && docker compose logs`

## Alternative: Install Bench (No Docker)

If you prefer not to use Docker, you can install Frappe Bench directly:

```bash
# Install dependencies
brew install python@3.11 mariadb redis

# Install bench
pip3 install frappe-bench

# Initialize bench
mkdir ~/frappe-bench
cd ~/frappe-bench
bench init --frappe-branch version-14 frappe-bench

# Create site
cd frappe-bench
bench new-site ethicslabs.localhost
bench --site ethicslabs.localhost add-to-hosts

# Install LMS
bench get-app lms /path/to/lms
bench --site ethicslabs.localhost install-app lms

# Build frontend
cd apps/lms
yarn install
yarn build

# Start server
bench start
```

See DEPLOYMENT_GUIDE.md for more details.

---

**Once Docker is installed, run `./LAUNCH.sh` to start the LMS!**
