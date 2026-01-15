# 🚀 Deploy Ethics Labs LMS to Railway - Quick Start

**TL;DR**: Deploy your fully-branded Ethics Labs LMS to Railway in under 15 minutes.

## What You'll Get
- ✅ Live Ethics Labs LMS at `your-app.up.railway.app`
- ✅ Automatic HTTPS/SSL
- ✅ MariaDB database & Redis cache
- ✅ All your custom branding (#0099ff colors, Jacquard 24 fonts, Ethics Labs logos)

## Prerequisites
1. **Railway account** → [railway.app/new](https://railway.app/new) (free tier works!)
2. **GitHub account** with your code pushed
3. **5-10 minutes** for first deployment

---

## Quick Deploy (3 Steps)

### Step 1: Create Railway Project from GitHub

1. Go to [railway.app/new](https://railway.app/new)
2. Click **"Deploy from GitHub repo"**
3. Authorize Railway to access your GitHub
4. Select your **`ethics-labs-lms`** repository

Railway will automatically detect `Dockerfile.railway` and `railway.json` ✅

### Step 2: Add Database Services

Railway needs 2 databases for Frappe:

**Add MariaDB:**
1. In your project, click **"+ New"** button
2. Select **"Database"** → **"Add MariaDB"**
3. Done! Railway creates these variables automatically:
   - `MYSQLHOST`, `MYSQLDATABASE`, `MYSQLUSER`, `MYSQLPASSWORD`

**Add Redis:**
1. Click **"+ New"** again
2. Select **"Database"** → **"Add Redis"**
3. Done! Railway creates:
   - `REDISHOST`, `REDISPORT`, `REDIS_URL`

### Step 3: Configure Environment Variables

Click on your **LMS service** (not the databases) → Go to **"Variables"** tab

Add these variables (copy-paste and modify):

```bash
# Link to MariaDB service
MYSQL_HOST=${{MariaDB.MYSQLHOST}}
MYSQL_ROOT_PASSWORD=${{MariaDB.MYSQLPASSWORD}}

# Link to Redis service
REDIS_HOST=${{Redis.REDISHOST}}
REDIS_PORT=${{Redis.REDISPORT}}

# Node version for Frappe
NODE_VERSION_DEVELOP=18
```

**Important**: Replace `MariaDB` and `Redis` with your actual service names if Railway named them differently (e.g., `MariaDB-1`, `Redis-1`)

Click **"Save"** and Railway will automatically redeploy!

---

## That's It! 🎉

**Wait 5-10 minutes** for the first deployment (Railway is installing Frappe + Ethics Labs LMS)

### Access Your LMS

1. Click on your LMS service
2. Click **"Settings"** → **"Networking"** → **"Generate Domain"**
3. Railway gives you: `https://ethics-labs-lms-production.up.railway.app`
4. Visit that URL → You'll see your Ethics Labs LMS! 🚀

**Default Login:**
- Username: `Administrator`
- Password: `admin`

⚠️ **Change this password immediately after first login!**

---

## Next Steps

### 1. Upload Your Branding

The logos are already in the code, but configure the site:

1. Login as `Administrator`
2. Go to **Website Settings**: `/app/website-settings`
3. Set **App Name**: `Ethics Labs`
4. Upload **Banner Image**: (optional, logo is already set)
5. Save

### 2. Add Custom Domain (Optional)

**Want `lms.ethicslabs.ai` instead of Railway subdomain?**

1. In your LMS service → **"Settings"** → **"Domains"**
2. Click **"Custom Domain"**
3. Enter: `lms.ethicslabs.ai`
4. Add this CNAME to your DNS:
   ```
   Type: CNAME
   Name: lms
   Value: ethics-labs-lms-production.up.railway.app
   ```
5. Wait 5-10 minutes for DNS propagation
6. Done! Railway auto-provisions SSL certificate ✅

### 3. Create Your First Course

1. Go to **LMS Course**: `/app/lms-course`
2. Click **"New"**
3. Add title, description, chapters, lessons
4. Publish!

---

## Troubleshooting

### Deployment Failed?

**Check logs:**
1. Click on your LMS service
2. Go to **"Deployments"** tab
3. Click the failed deployment → View logs

**Common issues:**
- ❌ Environment variables not set correctly
  - Solution: Double-check variable names match exactly
- ❌ Database connection failed
  - Solution: Verify `MYSQL_HOST` is `${{MariaDB.MYSQLHOST}}` (with your service name)
- ❌ Build timeout
  - Solution: Wait and try again (first build takes longest)

### Can't Access Site?

**Site shows error page:**
1. Wait 5 more minutes (initialization takes time)
2. Check all 3 services are running (green status)
3. View logs for errors

**502 Bad Gateway:**
- Still initializing, wait 2-3 minutes
- Or restart the service: **"Settings"** → **"Restart"**

### Database Issues?

**"Site already exists" error:**

If you need to reset:
1. Delete the MariaDB service
2. Create a new MariaDB service
3. Update the `MYSQL_HOST` variable in LMS service
4. Redeploy

---

## Cost Breakdown

**Railway Pricing:**
- **Hobby Plan**: $5/month (includes $5 credit)
  - Perfect for testing/personal use
  - Can handle ~100-500 users
- **Pro Plan**: $20/month (includes $20 credit)
  - Recommended for production
  - Custom domains, better performance

**Typical Usage:**
- Dev/Testing: ~$5-10/month
- Production (light): ~$15-25/month
- Production (heavy): ~$50+/month

First month often free with the $5 credit!

---

## Useful Commands (Railway CLI)

Install CLI: `npm install -g @railway/cli`

```bash
# Login
railway login

# Link to your project
railway link

# View logs in real-time
railway logs --follow

# Open in browser
railway open

# Check status
railway status

# Add environment variable
railway variables set KEY=value

# Restart service
railway restart
```

---

## What's Deployed?

Your Railway deployment includes:
- ✅ **Ethics Labs branding** (logo, colors, fonts)
- ✅ **#0099ff cyan blue** theme (from ethicslabs.ai)
- ✅ **Jacquard 24** fonts for headings
- ✅ **IBM Plex Sans** for body text
- ✅ **Custom certificates** with Ethics Labs decorations
- ✅ **"Where GenZ shapes the future of ethical AI"** tagline
- ✅ **Full LMS features**: courses, lessons, quizzes, certificates, batches, live classes

---

## Resources

- **Railway Dashboard**: [railway.app/dashboard](https://railway.app/dashboard)
- **Railway Docs**: [docs.railway.app](https://docs.railway.app)
- **Frappe Docs**: [frappeframework.com/docs](https://frappeframework.com/docs)
- **Railway Discord**: [discord.gg/railway](https://discord.gg/railway) (for support)

---

## Security Checklist

After deployment:
- [ ] Change Administrator password
- [ ] Add 2FA to admin account
- [ ] Review user permissions
- [ ] Set up backups (Railway Pro has automatic backups)
- [ ] Monitor logs regularly
- [ ] Keep Frappe/LMS updated

---

**Your Ethics Labs LMS is now live!** 🎓

Students can access courses at: `https://your-domain/lms`

Start creating courses and certificates!
