# 🚀 Fixed: Deploy Ethics Labs LMS to Railway

**Issues Fixed:**
- ✅ "bench: command not found" - Dockerfile now uses correct paths
- ✅ MySQL vs MariaDB - Railway's MySQL works perfectly
- ✅ Shebang error in init.sh fixed

---

## What Was Wrong & What's Fixed

### Issue 1: "bench: command not found"
**Problem:** The Dockerfile wasn't respecting the frappe/bench image structure.

**Fixed:**
- Changed working directory to `/home/frappe` (where bench expects to be)
- Set correct user (`frappe`)
- Fixed PATH to include bench commands
- Fixed shebang in init.sh: `#!/bin/bash` (was `#!bin/bash`)

### Issue 2: MariaDB vs MySQL
**Answer:** Railway only shows "MySQL" not "MariaDB" - **this is fine!**
- MySQL and MariaDB are compatible (MariaDB is a MySQL fork)
- Frappe works with both
- Use Railway's **MySQL** service, it works identically

---

## Deploy to Railway (Corrected Steps)

### Step 1: Push Updated Code to GitHub

```bash
cd "/Users/aniksahai/Desktop/Ethics Lab Learning Software/lms"

# Add the fixed files
git add .
git commit -m "Fix Railway deployment: bench command and Dockerfile"
git push origin main
```

### Step 2: Create Railway Project

1. Go to **[railway.app/new](https://railway.app/new)**
2. Click **"Deploy from GitHub repo"**
3. Select your repository
4. Railway will start building (this will take 5-10 minutes first time)

### Step 3: Add Database Services

**Add MySQL (not MariaDB - Railway calls it MySQL):**
1. Click **"+ New"** in your project
2. Select **"Database"** → **"Add MySQL"**
3. Railway creates these variables:
   - `MYSQLHOST`
   - `MYSQLPORT`
   - `MYSQLDATABASE`
   - `MYSQLUSER`
   - `MYSQLPASSWORD`
   - `MYSQL_URL`

**Add Redis:**
1. Click **"+ New"** again
2. Select **"Database"** → **"Add Redis"**
3. Railway creates:
   - `REDISHOST`
   - `REDISPORT`
   - `REDIS_URL`

### Step 4: Configure LMS Service Environment Variables

Click on your **LMS service** (the main app, not databases) → **"Variables"** tab

Add these exact variables:

```bash
# MySQL Configuration (links to your MySQL service)
MYSQL_HOST=${{MySQL.MYSQLHOST}}
MYSQL_ROOT_PASSWORD=${{MySQL.MYSQLPASSWORD}}

# Redis Configuration (links to your Redis service)
REDIS_HOST=${{Redis.REDISHOST}}
REDIS_PORT=${{Redis.REDISPORT}}

# Node version (required for Frappe)
NODE_VERSION_DEVELOP=18

# Optional: Custom site name
SITE_NAME=lms.localhost
```

**⚠️ Important:** Replace `MySQL` and `Redis` with your actual service names if Railway named them differently (check the service names in your project, they might be `MySQL-1`, `Redis-1`, etc.)

### Step 5: Verify Environment Variables

In your LMS service, check that these variables are properly linked:

Example (your IDs will be different):
```
MYSQL_HOST → railway.app (from MySQL service)
MYSQL_ROOT_PASSWORD → ••••••••• (from MySQL service)
REDIS_HOST → redis.railway.internal (from Redis service)
REDIS_PORT → 6379 (from Redis service)
NODE_VERSION_DEVELOP → 18 (manually set)
```

### Step 6: Deploy!

1. Railway will automatically redeploy when you save variables
2. Wait 5-10 minutes for first deployment
3. Watch the logs: Click your LMS service → **"Deployments"** → Click latest deployment

**What you should see in logs:**
```
✅ Creating new bench...
✅ Initializing Frappe Bench
✅ Getting LMS app
✅ Creating site lms.localhost
✅ Installing lms app
✅ Starting bench...
```

**NO MORE "bench: command not found" errors!** ✅

---

## Access Your LMS

### Generate Public URL

1. Click on your **LMS service**
2. Go to **"Settings"** → **"Networking"**
3. Click **"Generate Domain"**
4. Railway gives you: `https://ethics-labs-lms-production-xxxx.up.railway.app`

### First Login

Visit your Railway URL, you should see:
- **Ethics Labs branded login page**
- **#0099ff cyan blue colors**
- **Ethics Labs logo**

**Login with:**
- Username: `Administrator`
- Password: `admin`

⚠️ **Change this password immediately!**

---

## Troubleshooting

### Still Getting "bench: command not found"?

**Check deployment logs carefully:**
1. Click LMS service → "Deployments" → Latest deployment
2. Look for the build phase
3. You should see:
   ```
   Step 1/10 : FROM frappe/bench:latest
   Step 2/10 : USER frappe
   Step 3/10 : WORKDIR /home/frappe
   ...
   ```

**If you see errors:**
- Make sure you pushed the latest code with fixes
- Try redeploying: Click "Deploy" → "Redeploy"

### MySQL Connection Failed?

**Check these:**
1. MySQL service is running (green status)
2. `MYSQL_HOST` variable is correctly linked: `${{MySQL.MYSQLHOST}}`
3. `MYSQL_ROOT_PASSWORD` is linked: `${{MySQL.MYSQLPASSWORD}}`

**To test connection:**
```bash
# In Railway CLI
railway run bash
# Then try:
ping $MYSQL_HOST
```

### Redis Connection Failed?

Same checks as MySQL:
1. Redis service running
2. Variables correctly linked
3. Test with: `ping $REDIS_HOST`

### Deployment Timeout?

First deployment takes 5-10 minutes. If it times out:
1. Check Railway status page: [status.railway.app](https://status.railway.app)
2. Try redeploying
3. Check your Railway plan has enough resources

### Build Succeeds But Site Won't Load?

**Most common cause:** Initialization isn't complete yet.

**Solutions:**
1. **Wait longer** - First init takes 10-15 minutes
2. **Check logs** for actual errors (not warnings)
3. **Verify all 3 services are running** (LMS, MySQL, Redis)
4. **Try restarting**: Go to LMS service → "Settings" → "Restart"

### Site Loads But Shows Generic Frappe (Not Ethics Labs)?

**Solution:** Frontend build might not have completed.

```bash
# This shouldn't happen with the fixed Dockerfile, but if it does:
# The build process should automatically build the frontend
# If not, check that the build logs show:
# "Building frontend assets..."
```

---

## Verify Your Deployment

After successful deployment, check:

- [ ] Can access site at Railway URL
- [ ] See **Ethics Labs logo** (not Frappe logo)
- [ ] Colors are **#0099ff cyan blue**
- [ ] Login page says **"Ethics Labs"**
- [ ] Can login with Administrator/admin
- [ ] Dashboard shows **"Ethics Labs"** in header
- [ ] Fonts are **Jacquard 24** (headings) and **IBM Plex Sans** (body)

---

## Next Steps

### 1. Secure Your Instance

```bash
# Change admin password
1. Login as Administrator
2. Go to User Profile (top right)
3. Change Password
4. Set strong password
5. Enable 2FA (recommended)
```

### 2. Configure Website Settings

```bash
1. Go to: /app/website-settings
2. Set App Name: "Ethics Labs"
3. Upload banner image (logo)
4. Set tagline: "Where GenZ shapes the future of ethical AI"
5. Save
```

### 3. Create Your First Course

```bash
1. Go to: /app/lms-course
2. Click "New"
3. Fill in course details
4. Add chapters and lessons
5. Publish
```

### 4. Test Certificate Generation

```bash
1. Create a test user
2. Enroll them in your course
3. Go to: /app/lms-certificate
4. Create new certificate for test user
5. Verify it shows:
   - Ethics Labs branding
   - #0099ff blue borders
   - Decorative elements (brain, neural network)
```

### 5. Add Custom Domain (Optional)

See `RAILWAY_CUSTOM_DOMAIN.md` for detailed instructions.

Quick version:
1. LMS service → Settings → Domains → Add Custom Domain
2. Add CNAME in your DNS:
   - Type: CNAME
   - Name: lms
   - Value: your-railway-url.up.railway.app
3. Wait 5-10 minutes for DNS propagation
4. Access at: https://lms.ethicslabs.ai

---

## Railway CLI Commands

Useful commands after installation:

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Link to your project
railway link

# View logs in real-time
railway logs --follow

# Check service status
railway status

# Restart a service
railway restart

# Open in browser
railway open

# Run command in Railway environment
railway run [command]

# Add environment variable
railway variables set KEY=value
```

---

## Cost Monitoring

**Check your usage:**
1. Railway Dashboard → Your Project
2. Click on project settings (gear icon)
3. View "Usage" tab
4. Monitor:
   - CPU usage
   - Memory usage
   - Network bandwidth
   - Estimated monthly cost

**Typical costs for Ethics Labs LMS:**
- **Development/Testing**: $5-15/month
- **Production (100-500 users)**: $20-40/month
- **Production (500-2000 users)**: $50-100/month

Railway's Hobby plan includes $5 credit per month.

---

## Summary of Fixes

✅ **Fixed Dockerfile:**
- Uses correct user (`frappe`)
- Uses correct working directory (`/home/frappe`)
- Copies entire LMS app
- Sets correct PATH

✅ **Fixed init.sh:**
- Corrected shebang: `#!/bin/bash`
- Points to copied LMS app
- Uses environment variable for MySQL password

✅ **Clarified MySQL:**
- Railway's "MySQL" = MariaDB compatible
- Use MySQL service (not MariaDB)
- Variables link correctly

✅ **Deployment process:**
- Clear step-by-step instructions
- Correct environment variable linking
- Proper service naming

---

## Support

If you still have issues:

1. **Check Railway logs** (most issues show here)
2. **Verify all variables** are correctly set
3. **Ensure all 3 services are running**
4. **Check Railway Status**: [status.railway.app](https://status.railway.app)
5. **Railway Discord**: [discord.gg/railway](https://discord.gg/railway)

---

**Your Ethics Labs LMS should now deploy successfully!** 🎉

No more "bench: command not found" errors, and MySQL works perfectly.
