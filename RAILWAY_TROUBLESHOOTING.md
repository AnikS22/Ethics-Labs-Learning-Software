# Railway Deployment Troubleshooting Guide

## Common Issues and Fixes

### Issue 1: Node.js Not Found / "node: command not found"

**Error Messages:**
- `node: command not found`
- `which: no node in PATH`
- `Error: Cannot find module 'node'`

**Root Cause:**
The `init.sh` script was trying to use NVM path (`${NVM_DIR}/versions/node/v${NODE_VERSION_DEVELOP}/bin/`), but in the `frappe/bench` Docker image, Node.js is already installed in the system PATH.

**Fix Applied:**
✅ Updated `docker/init.sh` to:
1. Check if Node.js is already available in PATH
2. Only use NVM if it's actually installed and configured
3. Fall back to system Node.js if available

**Verification:**
Check Railway logs - you should now see:
```
Node.js found: /usr/bin/node (v18.x.x)
```
instead of errors about missing Node.js.

---

### Issue 2: "bench: command not found"

**Error Messages:**
- `bench: command not found`
- `bash: bench: command not found`
- `Error: bench init failed`

**Possible Causes:**
1. PATH doesn't include bench location
2. Bench isn't installed in the frappe/bench image
3. Working directory is wrong

**Fix:**
The `frappe/bench` image should have bench pre-installed. If not:

1. **Check Dockerfile.railway:**
   ```dockerfile
   ENV PATH="/home/frappe/.local/bin:${PATH}"
   ```
   This should include bench.

2. **In Railway, check build logs:**
   - Look for "Installing bench..." messages
   - Verify the Dockerfile builds correctly

3. **If bench still not found:**
   Add to Dockerfile.railway (before CMD):
   ```dockerfile
   RUN pip3 install --user frappe-bench || true
   ```

---

### Issue 3: MySQL/MariaDB Connection Failed

**Error Messages:**
- `Error: (2003, "Can't connect to MySQL server")`
- `Connection refused`
- `Access denied for user`

**Fix:**
1. **Check Environment Variables in Railway:**
   - Go to your LMS service → Variables tab
   - Verify these are set correctly:
     ```
     MYSQL_HOST=${{MySQL.MYSQLHOST}}
     MYSQL_ROOT_PASSWORD=${{MySQL.MYSQLPASSWORD}}
     ```
   - ⚠️ **Important:** Replace `MySQL` with your actual MySQL service name (might be `MySQL-1`, `mysql`, etc.)

2. **Verify MySQL Service is Running:**
   - Check Railway dashboard - MySQL service should be green/running
   - If not, restart it

3. **Test Connection:**
   ```bash
   # In Railway CLI (if available)
   railway run bash
   ping $MYSQL_HOST  # Should respond
   ```

4. **Check Railway Service Names:**
   - In Railway dashboard, check the exact name of your MySQL service
   - Use that name in the environment variable: `${{YourActualServiceName.MYSQLHOST}}`

---

### Issue 4: Redis Connection Failed

**Error Messages:**
- `Error connecting to Redis`
- `Redis connection refused`
- `Cannot connect to redis://...`

**Fix:**
1. **Check Environment Variables:**
   ```
   REDIS_HOST=${{Redis.REDISHOST}}
   REDIS_PORT=${{Redis.REDISPORT}}
   ```
   - Again, replace `Redis` with your actual Redis service name

2. **Verify Redis Service:**
   - Check Railway dashboard - Redis service should be running
   - Restart if needed

3. **Test Connection:**
   ```bash
   ping $REDIS_HOST  # Should respond
   ```

---

### Issue 5: Build Succeeds But Site Won't Load

**Symptoms:**
- Build completes successfully
- No errors in logs
- But visiting the URL returns 502/503/Connection refused

**Possible Causes:**
1. **Initialization not complete** (most common)
   - First-time initialization takes 10-15 minutes
   - Bench needs to install Frappe, get LMS app, create site, install app

2. **Port binding issues**
   - Railway uses `$PORT` environment variable
   - Frappe bench by default uses port 8000

**Fix:**
1. **Wait Longer:**
   - First deployment takes 10-15 minutes
   - Watch logs for "Starting bench..." and "Site created successfully"

2. **Check Railway Logs:**
   - Go to LMS service → Deployments → Latest deployment
   - Look for:
     ```
     ✅ Creating new bench...
     ✅ Initializing Frappe Bench
     ✅ Getting LMS app
     ✅ Creating site lms.localhost
     ✅ Installing lms app
     ✅ Starting bench...
     ```

3. **Check if Process is Running:**
   - In logs, look for "Listening on http://..."
   - Should show port 8000 or Railway's assigned port

4. **Verify Port Configuration:**
   Railway might use a different port. Check Railway's environment variables:
   - Railway automatically sets `PORT` variable
   - You might need to configure bench to use `$PORT`

---

### Issue 6: Railway Says "Container Exited" or "Service Crashed"

**Error Messages:**
- `Container exited with code 1`
- `Service crashed`
- `Process exited unexpectedly`

**Fix:**
1. **Check Full Logs:**
   - Railway dashboard → LMS service → Logs tab
   - Look for the last error before exit
   - Common causes:
     - Database connection failed
     - Missing environment variables
     - Node.js not found (should be fixed now)
     - Permission issues

2. **Check Exit Code:**
   - Exit code 0 = Success (normal shutdown)
   - Exit code 1 = Error (check logs)
   - Exit code 137 = Out of memory (upgrade Railway plan)

3. **Common Errors to Look For:**
   - `bench: command not found` → Fix: See Issue 2
   - `node: command not found` → Fix: See Issue 1 (should be fixed)
   - `Can't connect to MySQL` → Fix: See Issue 3
   - `Permission denied` → Fix: Check file permissions in Dockerfile

---

### Issue 7: Build Fails with Dockerfile Errors

**Error Messages:**
- `COPY failed: file not found`
- `RUN command failed`
- `Dockerfile build failed`

**Fix:**
1. **Check File Paths:**
   - Verify `Dockerfile.railway` exists in root directory
   - Check that `docker/init.sh` exists
   - Ensure COPY paths are correct

2. **Check railway.json:**
   ```json
   {
     "build": {
       "builder": "DOCKERFILE",
       "dockerfilePath": "Dockerfile.railway"
     }
   }
   ```
   - `dockerfilePath` should be relative to repository root

3. **Verify Dockerfile Syntax:**
   - Check for typos in Dockerfile
   - Ensure all COPY commands reference existing files
   - Check RUN commands are valid

---

### Issue 8: Environment Variables Not Working

**Symptoms:**
- Environment variables set in Railway but not available in container
- Script can't access `$MYSQL_HOST`, etc.

**Fix:**
1. **Check Variable Names:**
   - Railway variable names are case-sensitive
   - Use exact names: `MYSQL_HOST`, `MYSQL_ROOT_PASSWORD`, etc.

2. **Check Service Linking:**
   - For service-linked variables, use format: `${{ServiceName.VARIABLE}}`
   - Example: `${{MySQL.MYSQLHOST}}`
   - ⚠️ Service name must match exactly (check Railway dashboard)

3. **Verify Variables are Set:**
   - In Railway dashboard → LMS service → Variables tab
   - Should show all variables with values
   - Green checkmark = linked correctly
   - Red X = not linked (fix the service name)

4. **In init.sh, Use Default Values:**
   ```bash
   MARIADB_HOST="${MYSQL_HOST:-mariadb}"  # Uses 'mariadb' if MYSQL_HOST not set
   ```
   This provides fallbacks for local Docker testing.

---

## Step-by-Step Debugging

### 1. Check Railway Logs
```
Railway Dashboard → Your Project → LMS Service → Deployments → Latest → View Logs
```

Look for:
- ✅ Success messages
- ❌ Error messages
- ⚠️ Warning messages

### 2. Verify All Services Are Running
- MySQL service: Should be green/running
- Redis service: Should be green/running
- LMS service: Should be green/running

### 3. Check Environment Variables
```
Railway Dashboard → LMS Service → Variables Tab
```

Verify:
- `MYSQL_HOST=${{MySQL.MYSQLHOST}}` (replace MySQL with your service name)
- `MYSQL_ROOT_PASSWORD=${{MySQL.MYSQLPASSWORD}}`
- `REDIS_HOST=${{Redis.REDISHOST}}` (replace Redis with your service name)
- `REDIS_PORT=${{Redis.REDISPORT}}`
- `NODE_VERSION_DEVELOP=18` (optional, but recommended)

### 4. Test Build Locally (Optional)
```bash
# Build the Dockerfile locally to check for errors
cd "/Users/aniksahai/Desktop/Ethics Lab Learning Software/lms"
docker build -f Dockerfile.railway -t ethics-labs-lms:test .
```

If this fails, the same errors will happen on Railway.

### 5. Check Railway Status
- Visit: https://status.railway.app
- Check if Railway is experiencing issues

---

## Quick Checklist

Before deploying to Railway, verify:

- [ ] `Dockerfile.railway` exists in repository root
- [ ] `docker/init.sh` exists and is executable
- [ ] `railway.json` references correct Dockerfile path
- [ ] All code is pushed to GitHub
- [ ] MySQL service created in Railway
- [ ] Redis service created in Railway
- [ ] Environment variables are correctly linked
- [ ] Service names in environment variables match Railway service names exactly

---

## Getting Help

### Railway Logs
1. Railway Dashboard → Your Project → LMS Service
2. Click "Deployments" tab
3. Click latest deployment
4. Click "View Logs" or "Raw Logs"

### Railway Support
- Railway Discord: https://discord.gg/railway
- Railway Docs: https://docs.railway.app
- Railway Status: https://status.railway.app

### Frappe/LMS Documentation
- Frappe Docs: https://frappeframework.com/docs
- Frappe LMS GitHub: https://github.com/frappe/lms

---

## Recent Fixes Applied

✅ **Fixed Node.js PATH Issue** (2024-01-XX):
- Updated `docker/init.sh` to check for Node.js in PATH first
- Only uses NVM if actually installed and configured
- Falls back to system Node.js
- Should fix "node: command not found" errors

---

## Still Having Issues?

If you're still experiencing problems after trying these fixes:

1. **Copy the exact error message** from Railway logs
2. **Screenshot the error** if possible
3. **Check which issue number** from above matches your error
4. **Verify all environment variables** are set correctly
5. **Check Railway service status** (all services running?)

Most Railway deployment issues are related to:
- Environment variables not linked correctly (Issue 3, 4, 8)
- Node.js/bench not found (Issue 1, 2) - **FIXED**
- Services not running (Issue 3, 4)
- Initialization not complete (Issue 5)

---

**Your deployment should work now with the Node.js fix! 🚀**
