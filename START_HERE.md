# 🚀 START HERE - Launch Your Ethics Lab LMS

## Why You Don't See It on localhost:8000

**Docker is not installed or not running.** The LMS needs Docker to run locally.

## Quick Fix - Install Docker

### Step 1: Install Docker Desktop

**macOS (Easiest Way):**
```bash
brew install --cask docker
```

Or download directly:
- Visit: https://www.docker.com/products/docker-desktop/
- Download for Mac
- Install and open Docker Desktop

### Step 2: Start Docker Desktop

1. Open **Docker Desktop** from Applications
2. Wait for it to start (whale icon in menu bar should be steady)
3. Make sure it says "Docker Desktop is running"

### Step 3: Launch the LMS

Once Docker is running, execute:

```bash
cd "/Users/aniksahai/Desktop/Ethics Lab Learning Software/lms"
./LAUNCH.sh
```

Or manually:
```bash
cd "/Users/aniksahai/Desktop/Ethics Lab Learning Software/lms/docker"
docker compose up -d
```

### Step 4: Wait and Access

1. **Wait 2-3 minutes** for containers to start (first time takes longer)
2. **Open your browser**: http://localhost:8000
3. **Complete the setup wizard**
4. **Install the LMS app**

## Alternative: Check if Docker is Running

If you think Docker is installed:

```bash
# Check if Docker is running
docker ps

# If that works, start the LMS
cd "/Users/aniksahai/Desktop/Ethics Lab Learning Software/lms/docker"
docker compose up -d
```

## Troubleshooting

### "docker: command not found"
- Docker is not installed → Install Docker Desktop (see Step 1)

### "Cannot connect to Docker daemon"
- Docker Desktop is not running → Open Docker Desktop app

### Port 8000 already in use
- Something else is using port 8000
- Stop it or change the port in `docker/docker-compose.yml`

### Containers start but site doesn't load
- Wait longer (first startup takes 3-5 minutes)
- Check logs: `cd docker && docker compose logs`
- Make sure you're going to http://localhost:8000 (not https)

## What You'll See

Once it's running:
1. **Setup Wizard** at http://localhost:8000
   - Create admin account
   - Set site name
   
2. **Admin Dashboard** after login
   - Install LMS app
   - Create courses
   - Generate certificates

3. **Public LMS** at http://localhost:8000/lms
   - Course listings
   - Student interface

## Quick Commands

```bash
# Start LMS
cd lms/docker && docker compose up -d

# Stop LMS
cd lms/docker && docker compose down

# View logs
cd lms/docker && docker compose logs -f

# Check status
cd lms/docker && docker compose ps
```

## Need Help?

- **Docker Installation**: See `INSTALL_DOCKER.md`
- **Testing Guide**: See `TESTING_GUIDE.md`
- **Quick Test**: See `QUICK_TEST.md`

---

**Next Step: Install Docker Desktop, then run `./LAUNCH.sh`**
