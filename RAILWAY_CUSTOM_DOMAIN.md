# Setting Up Custom Domain on Railway - Quick Guide

## Quick Steps for Custom Domain

### Step 1: Deploy Your App on Railway

1. Go to https://railway.app
2. Click "New Project" → "Deploy from GitHub repo"
3. Select: `AnikS22/Ethics-Labs-Learning-Software`
4. Add MySQL database (click "+ New" → "MySQL")

### Step 2: Add Custom Domain in Railway

1. **In Railway Dashboard:**
   - Go to your deployed service
   - Click "Settings" tab
   - Scroll to "Domains" section

2. **Click "Add Custom Domain"**
   - Enter your domain: `lms.ethicslabs.ai` (subdomain)
   - Or: `ethicslabs.ai` (root domain)

3. **Railway will show you DNS records to add:**
   ```
   For subdomain (lms.ethicslabs.ai):
   Type: CNAME
   Name: lms
   Value: yourapp.up.railway.app
   ```

   ```
   For root domain (ethicslabs.ai):
   Type: A
   Name: @
   Value: 123.456.789.0 (Railway's IP address)
   ```

### Step 3: Update DNS at Your Domain Registrar

#### Where to Add DNS Records:

**Namecheap:**
1. Go to Domain List → Click "Manage"
2. Go to "Advanced DNS" tab
3. Click "Add New Record"
4. Select type (CNAME or A)
5. Enter Name and Value from Railway
6. Save

**GoDaddy:**
1. Go to My Products → Domains
2. Click your domain → DNS
3. Click "Add" → Select record type
4. Enter details from Railway
5. Save

**Cloudflare:**
1. Select your domain
2. Go to DNS → Records
3. Click "Add record"
4. Select type → Enter details
5. Save

**Google Domains:**
1. Open your domain
2. Go to DNS → Custom records
3. Add record with Railway's details
4. Save

### Step 4: Wait for DNS Propagation

- Usually takes **15-30 minutes**
- Can take up to **48 hours** (rare)
- Check at: https://dnschecker.org

### Step 5: SSL Certificate (Automatic)

✅ **Railway automatically provisions SSL certificates!**

- Once DNS propagates, Railway will:
  1. Detect your domain
  2. Request SSL certificate from Let's Encrypt
  3. Install it automatically
  4. Your site will be available at `https://yourdomain.com`

**No manual configuration needed!**

## DNS Record Examples

### Subdomain Setup (lms.ethicslabs.ai)

**In Railway:**
- Domain: `lms.ethicslabs.ai`
- Railway shows: `Type: CNAME, Value: yourapp.up.railway.app`

**At Domain Registrar:**
```
Type: CNAME
Name: lms
Value: yourapp.up.railway.app
TTL: 3600 (or Auto)
Proxy: Off (if using Cloudflare, turn off proxy during setup)
```

### Root Domain Setup (ethicslabs.ai)

**In Railway:**
- Domain: `ethicslabs.ai`
- Railway may provide an A record or CNAME

**At Domain Registrar:**

**Option 1: A Record (if Railway provides IP)**
```
Type: A
Name: @
Value: 123.456.789.0 (Railway's IP)
TTL: 3600
```

**Option 2: CNAME (if Railway allows)**
```
Type: CNAME
Name: @
Value: yourapp.up.railway.app
TTL: 3600
```

**Note:** Some registrars don't allow CNAME for root domain. Use A record in that case.

## Verification

### Check DNS Propagation

```bash
# Command line
nslookup lms.ethicslabs.ai
dig lms.ethicslabs.ai

# Online tools
https://dnschecker.org
https://whatsmydns.net
```

**Expected Result:**
- Should show Railway's IP address or CNAME target

### Check SSL Certificate

Once DNS is propagated:
1. Railway dashboard → Domains → Should show "Certificate Provisioned"
2. Visit `https://yourdomain.com` → Should load with SSL lock icon
3. SSL is usually active within **5-10 minutes** after DNS propagates

## Troubleshooting

### Domain Not Working After DNS Setup

**Wait Time:**
- ✅ Minimum: 5 minutes
- ✅ Usually: 15-30 minutes
- ⚠️ Maximum: 48 hours (rare)

**Check:**
1. DNS propagation: https://dnschecker.org
2. Railway dashboard → Domains → Check status
3. Verify DNS records match Railway's requirements exactly

### SSL Certificate Not Provisioned

**Common Causes:**
1. DNS not fully propagated → Wait longer
2. DNS records incorrect → Double-check at registrar
3. Domain already has certificate → May need to wait for renewal

**Solution:**
- Wait for DNS to fully propagate (check multiple DNS servers)
- Verify DNS records are correct
- Check Railway dashboard for certificate errors

### Site Not Accessible

**Check:**
1. Is Railway service running? (check Railway dashboard)
2. Is database connected? (check environment variables)
3. Are DNS records correct? (verify at registrar)
4. Is DNS propagated? (use dnschecker.org)

## Common Issues

### Issue: "Domain already in use"
- Another Railway service may be using it
- Check Railway dashboard for conflicts

### Issue: "DNS verification failed"
- DNS records not configured correctly
- DNS not propagated yet
- Double-check records match Railway exactly

### Issue: "Certificate failed to provision"
- DNS not fully propagated
- DNS records pointing to wrong place
- Domain has DNS errors

## Important Notes

### DNS TTL
- Lower TTL (300 seconds) = faster updates
- Higher TTL (3600 seconds) = less DNS queries
- For setup, use 300-600 seconds
- After setup, increase to 3600

### Cloudflare Proxy
If using Cloudflare:
- Turn off proxy (orange cloud) during setup
- After SSL is active, you can enable proxy
- Proxy can cause SSL issues during initial setup

### Root vs Subdomain
- **Subdomain** (lms.ethicslabs.ai): Easier, use CNAME
- **Root domain** (ethicslabs.ai): May require A record, check Railway's instructions

## After Domain is Connected

1. **Update Site Configuration:**
   - Login to Frappe admin
   - Go to Website Settings
   - Update site name to your domain

2. **Test Everything:**
   - Visit your domain
   - Test login/signup
   - Test course enrollment
   - Test certificate generation

3. **Set Up Email** (for notifications):
   - Configure email settings in Frappe
   - Use SMTP or email service

## Quick Checklist

- [ ] Railway project created
- [ ] App deployed on Railway
- [ ] MySQL database added
- [ ] Custom domain added in Railway
- [ ] DNS records added at registrar
- [ ] DNS propagated (checked via dnschecker.org)
- [ ] SSL certificate provisioned
- [ ] Site accessible at https://yourdomain.com
- [ ] Site configuration updated in Frappe

---

**That's it! Railway handles SSL automatically once DNS is set up correctly.**

See `RAILWAY_DEPLOYMENT.md` for full deployment guide.
