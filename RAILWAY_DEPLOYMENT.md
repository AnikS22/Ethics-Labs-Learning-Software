# Deploy Ethics Labs LMS on Railway with Custom Domain

This guide shows you how to deploy your Ethics Labs LMS on Railway and connect your custom domain.

## Overview

Railway is a modern cloud platform that makes deploying applications easy. You can deploy your LMS there and connect your custom domain (e.g., `ethicslabs.ai` or `lms.ethicslabs.ai`).

## Prerequisites

- Railway account (sign up at https://railway.app)
- Custom domain (from any registrar like Namecheap, GoDaddy, Cloudflare, etc.)
- Your Ethics Labs LMS code (already on GitHub)

## Step 1: Prepare Your Project for Railway

### Option A: Deploy from GitHub (Recommended)

Since your code is already on GitHub:

1. **Ensure your repository is ready**
   - All code is committed and pushed
   - Repository is accessible at: https://github.com/AnikS22/Ethics-Labs-Learning-Software

2. **Create a `railway.json` file** (optional, for configuration)

### Option B: Use Railway's One-Click Deploy

Railway can auto-detect Frappe/LMS setups, but you may need to configure it.

## Step 2: Deploy to Railway

### 1. Sign Up / Login to Railway

1. Go to https://railway.app
2. Click "Start a New Project"
3. Choose "Deploy from GitHub repo"
4. Select your repository: `AnikS22/Ethics-Labs-Learning-Software`

### 2. Configure Environment Variables

Railway will need these environment variables:

```bash
# Database (Railway provides PostgreSQL by default)
# For Frappe, you'll want to use MariaDB instead

# Application Settings
SITE_NAME=ethicslabs.localhost
ADMIN_PASSWORD=your-secure-password
DB_NAME=your_db_name
DB_PASSWORD=your_db_password

# Optional
DEVELOPER_MODE=0
```

**Important**: Frappe/LMS uses MariaDB/MySQL, not PostgreSQL. Railway supports both, but you'll need to:

**Option 1: Use Railway's MySQL Plugin**
1. In your Railway project, click "+ New"
2. Select "MySQL" (or "MariaDB" if available)
3. This will create a MySQL database automatically
4. Railway will provide connection details as environment variables

**Option 2: Use External Database**
- Use a managed MariaDB service (like PlanetScale, Aiven, or DigitalOcean)
- Add connection details as environment variables

### 3. Configure Build Settings

Railway will detect it's a Python project. You may need to configure:

**Build Command:**
```bash
# Railway will detect Python automatically
# You may need to specify:
pip install -r requirements.txt
# or
pip install frappe-bench
```

**Start Command:**
```bash
# This depends on how you set up the app
bench start
# or
python -m frappe.app
```

## Step 3: Set Up Custom Domain

### 1. Add Custom Domain in Railway

1. **Go to your Railway project**
   - Click on your deployed service
   - Go to the "Settings" tab
   - Scroll to "Domains" section

2. **Add Custom Domain**
   - Click "Add Domain" or "Generate Domain"
   - Enter your custom domain (e.g., `lms.ethicslabs.ai` or `ethicslabs.ai`)
   - Railway will show you what DNS records to add

### 2. Configure DNS Records

Railway will provide you with DNS records. You'll typically need:

**For Root Domain (ethicslabs.ai):**
```
Type: A
Name: @
Value: [Railway-provided IP address]
```

**For Subdomain (lms.ethicslabs.ai):**
```
Type: CNAME
Name: lms
Value: [Railway-provided domain, e.g., yourapp.up.railway.app]
```

### 3. Update DNS at Your Domain Registrar

1. **Go to your domain registrar** (Namecheap, GoDaddy, Cloudflare, etc.)
2. **Access DNS settings**
3. **Add the DNS records** Railway provided:
   - Type (A or CNAME)
   - Name (host/subdomain)
   - Value (Railway's IP or domain)
   - TTL (3600 or default)

**Example for Namecheap:**
- Go to Domain List → Manage → Advanced DNS
- Add A Record or CNAME Record as shown by Railway

**Example for Cloudflare:**
- Go to DNS → Records
- Add A or CNAME record
- Set Proxy status (toggle orange cloud) if desired

### 4. Wait for DNS Propagation

- DNS changes take **5 minutes to 48 hours** to propagate
- Usually takes **15-30 minutes**
- Check propagation: https://dnschecker.org

### 5. SSL Certificate (Automatic)

Railway automatically provisions SSL certificates via Let's Encrypt:
- Once DNS is configured and propagated
- Railway will automatically add SSL
- Your site will be available at `https://yourdomain.com`

## Step 4: Configure the Application

### Update Site Configuration

Once your domain is connected:

1. **Access your Railway app**
   - Use Railway's provided domain or your custom domain
   - Complete the Frappe setup wizard

2. **Configure site name**
   - In Frappe, go to Site Settings
   - Update site name to match your domain

3. **Update site config**
   ```bash
   # If you have CLI access to Railway
   bench --site your-domain.com set-config developer_mode 0
   ```

## Step 5: Environment Variables for Custom Domain

Set these in Railway's environment variables:

```bash
# Site Configuration
SITE_NAME=your-domain.com
SITE_URL=https://your-domain.com

# Database (provided by Railway's MySQL plugin)
DB_HOST=${{MySQL.MYSQLHOST}}
DB_PORT=${{MySQL.MYSQLPORT}}
DB_NAME=${{MySQL.MYSQLDATABASE}}
DB_USER=${{MySQL.MYSQLUSER}}
DB_PASSWORD=${{MySQL.MYSQLPASSWORD}}

# Application
ADMIN_PASSWORD=your-secure-password
DEVELOPER_MODE=0
```

## Step-by-Step: Railway Deployment

### 1. Create Railway Project

```bash
# Install Railway CLI (optional)
npm i -g @railway/cli

# Login
railway login

# Initialize project
railway init

# Link to existing project (or create new)
railway link
```

Or use the web interface:
1. Go to https://railway.app
2. New Project → Deploy from GitHub
3. Select your repository

### 2. Add MySQL Database

1. In Railway dashboard → Your Project
2. Click "+ New"
3. Select "MySQL" (or "Add Service" → "Database" → "MySQL")
4. Railway will automatically create a MySQL database
5. Connection details will be in environment variables

### 3. Configure Build

Railway may auto-detect, but you can specify:

**railway.json** (in project root):
```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS",
    "buildCommand": "pip install -r requirements.txt"
  },
  "deploy": {
    "startCommand": "bench start",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

### 4. Add Custom Domain

**In Railway Dashboard:**
1. Select your service
2. Go to "Settings" tab
3. Scroll to "Domains"
4. Click "Generate Domain" (this gives you Railway's domain)
5. Click "Add Custom Domain"
6. Enter your domain: `lms.ethicslabs.ai` (or `ethicslabs.ai`)

**Railway will show:**
```
Configure your DNS:
Type: CNAME
Name: lms
Value: yourapp.up.railway.app
```

### 5. Update DNS

**At your domain registrar:**

**For Subdomain (lms.ethicslabs.ai):**
```
Type: CNAME
Name: lms
Value: yourapp.up.railway.app
TTL: 3600
```

**For Root Domain (ethicslabs.ai):**
Railway may provide an A record IP address:
```
Type: A
Name: @
Value: 123.456.789.0 (Railway's IP)
TTL: 3600
```

### 6. Verify DNS

```bash
# Check DNS propagation
nslookup lms.ethicslabs.ai
# or
dig lms.ethicslabs.ai

# Should return Railway's IP or CNAME
```

### 7. Wait for SSL

- Railway automatically provisions SSL
- Check in Railway dashboard → Domains
- Should show "Certificate Provisioned" after DNS propagates

## Railway-Specific Configuration

### For Frappe/LMS on Railway

You'll need to handle:

1. **Database**: Use Railway's MySQL plugin
2. **Redis**: May need to add Redis service or use external Redis
3. **File Storage**: Railway's filesystem is ephemeral - consider S3 for production
4. **Port Configuration**: Railway automatically handles port binding

### Environment Variables Template

```bash
# Database (from Railway MySQL plugin)
MYSQL_HOST=${{MySQL.MYSQLHOST}}
MYSQL_PORT=${{MySQL.MYSQLPORT}}
MYSQL_DATABASE=${{MySQL.MYSQLDATABASE}}
MYSQL_USER=${{MySQL.MYSQLUSER}}
MYSQL_PASSWORD=${{MySQL.MYSQLPASSWORD}}

# Site
SITE_NAME=lms.ethicslabs.ai
SITE_URL=https://lms.ethicslabs.ai

# Redis (if adding Redis service)
REDIS_URL=${{Redis.REDIS_URL}}

# Admin
ADMIN_PASSWORD=your-secure-password

# Email (for notifications)
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
```

## Troubleshooting

### Domain Not Resolving

1. **Check DNS propagation**: https://dnschecker.org
2. **Verify DNS records** at your registrar match Railway's requirements
3. **Wait longer**: DNS can take up to 48 hours (usually 15-30 min)
4. **Check TTL**: Lower TTL (300) for faster updates

### SSL Not Working

1. **Wait for DNS propagation** (SSL can't provision until DNS works)
2. **Check Railway dashboard** → Domains → Certificate status
3. **Verify domain** is correctly added in Railway
4. **Check certificate logs** in Railway

### Application Not Starting

1. **Check build logs** in Railway dashboard
2. **Verify environment variables** are set correctly
3. **Check database connection** (ensure MySQL is running)
4. **Review application logs** in Railway dashboard

### Database Connection Issues

1. **Verify MySQL service** is running in Railway
2. **Check environment variables** match Railway's MySQL plugin
3. **Ensure database** is accessible from your app service
4. **Check connection string** format

## Railway Pricing

**Free Tier:**
- $5 credit/month
- Good for testing/small projects

**Hobby Plan:**
- $5/month + usage
- Better for small production sites

**Pro Plan:**
- $20/month + usage
- Better resources for production

**Cost Estimate for LMS:**
- Small site: ~$10-20/month
- Medium traffic: ~$30-50/month
- Large traffic: ~$50-100+/month

## Alternative: Railway + External Services

If Railway's MySQL isn't sufficient:

1. **Database**: Use PlanetScale, Aiven, or DigitalOcean Managed MySQL
2. **File Storage**: Use AWS S3 or Cloudflare R2
3. **Redis**: Use Upstash or Railway's Redis service

## Next Steps After Deployment

1. **Configure Email** (for notifications)
2. **Set up backups** (Railway doesn't auto-backup databases)
3. **Configure file storage** (for user uploads)
4. **Set up monitoring** (Railway has basic monitoring)
5. **Configure custom branding** (Website Settings in Frappe)

## Support

- **Railway Docs**: https://docs.railway.app
- **Railway Discord**: https://discord.gg/railway
- **Frappe Docs**: https://frappeframework.com/docs

---

**Your custom domain will work automatically once DNS propagates! 🚀**
