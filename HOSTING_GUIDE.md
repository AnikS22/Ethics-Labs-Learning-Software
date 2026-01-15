# Hosting Ethics Labs LMS on the Web

This guide covers multiple options for hosting your Ethics Labs LMS online.

## Quick Comparison

| Option | Difficulty | Cost | Best For |
|--------|-----------|------|----------|
| **Frappe Cloud** | ⭐ Easy | $5-50/month | Quick launch, managed |
| **VPS (DigitalOcean/Linode)** | ⭐⭐ Medium | $12-40/month | Full control, custom domain |
| **AWS/GCP/Azure** | ⭐⭐⭐ Advanced | Varies | Enterprise, scaling |
| **Docker on VPS** | ⭐⭐ Medium | $12-40/month | Containerized deployment |

## Option 1: Frappe Cloud (Easiest - Recommended)

Frappe Cloud is the official managed hosting platform for Frappe apps.

### Step 1: Sign Up
1. Visit: https://frappecloud.com
2. Sign up for an account
3. Choose a plan (starts at $5/month)

### Step 2: Create a New Site
1. Click "New Site"
2. Choose "Install App"
3. Select "LMS" from the app list
4. Enter your site name (e.g., `ethicslabs`)
5. Your site will be: `ethicslabs.frappe.cloud`

### Step 3: Custom Domain (Optional)
1. In site settings, add your custom domain
2. Update DNS records as instructed
3. SSL certificate is automatically provisioned

### Step 4: Configure Your Site
1. Login to your site
2. Go to Website Settings → Set App Name to "Ethics Labs"
3. Upload your logos and branding
4. Configure LMS Settings

**Pros:**
- ✅ Easiest setup (5 minutes)
- ✅ Automatic SSL certificates
- ✅ Automatic backups
- ✅ Managed updates
- ✅ No server management

**Cons:**
- ❌ Limited customization
- ❌ Monthly cost
- ❌ Subdomain unless you add custom domain

**Cost:** $5-50/month depending on usage

---

## Option 2: VPS Hosting (DigitalOcean/Linode/AWS)

Full control with a virtual private server.

### Step 1: Create a VPS

**DigitalOcean:**
1. Sign up: https://www.digitalocean.com
2. Create a Droplet:
   - **OS**: Ubuntu 22.04 LTS
   - **Size**: 2GB RAM minimum (4GB recommended)
   - **Region**: Choose closest to your users
   - **Add SSH key** for secure access

**Linode:**
1. Sign up: https://www.linode.com
2. Create a Linode (same specs as above)

**AWS EC2:**
1. Sign up: https://aws.amazon.com
2. Launch EC2 instance (t3.small or larger)

### Step 2: Initial Server Setup

SSH into your server:
```bash
ssh root@your-server-ip
```

Update system:
```bash
apt update && apt upgrade -y
```

### Step 3: Install Dependencies

```bash
# Install Python and dependencies
apt-get install -y python3-dev python3-pip python3-venv git curl

# Install MariaDB
apt-get install -y mariadb-server mariadb-client

# Install Redis
apt-get install -y redis-server

# Install Node.js and Yarn
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs
npm install -g yarn

# Install Nginx
apt-get install -y nginx

# Install Supervisor
apt-get install -y supervisor
```

### Step 4: Configure MariaDB

```bash
# Secure MariaDB installation
mysql_secure_installation

# Create database and user
mysql -u root -p
```

In MySQL:
```sql
CREATE DATABASE ethicslabs CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'ethicslabs'@'localhost' IDENTIFIED BY 'your-secure-password';
GRANT ALL PRIVILEGES ON ethicslabs.* TO 'ethicslabs'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Step 5: Install Bench and LMS

```bash
# Install bench
pip3 install frappe-bench

# Create bench directory
mkdir ~/frappe-bench
cd ~/frappe-bench

# Initialize bench
bench init --frappe-branch version-14 frappe-bench

# Enter bench directory
cd frappe-bench

# Get LMS app
bench get-app lms /path/to/your/lms/directory

# Or clone from GitHub
bench get-app https://github.com/frappe/lms
```

### Step 6: Create Site

```bash
# Create new site
bench new-site ethicslabs.yourdomain.com \
  --mariadb-root-password your-root-password \
  --admin-password your-admin-password

# Install LMS app
bench --site ethicslabs.yourdomain.com install-app lms

# Build frontend assets
cd apps/lms
yarn install
yarn build
cd ../..
```

### Step 7: Configure Nginx

Create Nginx config:
```bash
sudo nano /etc/nginx/sites-available/ethicslabs
```

Add:
```nginx
server {
    listen 80;
    server_name ethicslabs.yourdomain.com;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Enable site:
```bash
ln -s /etc/nginx/sites-available/ethicslabs /etc/nginx/sites-enabled/
nginx -t
systemctl reload nginx
```

### Step 8: Set Up SSL with Let's Encrypt

```bash
# Install Certbot
apt-get install -y certbot python3-certbot-nginx

# Get SSL certificate
certbot --nginx -d ethicslabs.yourdomain.com

# Auto-renewal is set up automatically
```

### Step 9: Set Up Supervisor (Process Management)

Create supervisor config:
```bash
sudo nano /etc/supervisor/conf.d/frappe.conf
```

Add:
```ini
[program:frappe]
command=/home/your-user/frappe-bench/frappe-bench/env/bin/bench serve --port 8000
directory=/home/your-user/frappe-bench/frappe-bench
user=your-user
autostart=true
autorestart=true
redirect_stderr=true
stdout_logfile=/var/log/frappe.log
```

Reload supervisor:
```bash
supervisorctl reread
supervisorctl update
supervisorctl start frappe
```

### Step 10: Configure DNS

1. Go to your domain registrar
2. Add A record:
   - **Name**: `@` or `ethicslabs`
   - **Value**: Your server IP address
   - **TTL**: 3600

3. Wait for DNS propagation (5 minutes to 48 hours)

**Pros:**
- ✅ Full control
- ✅ Custom domain
- ✅ Scalable
- ✅ Cost-effective

**Cons:**
- ❌ Requires server management
- ❌ You handle updates and backups
- ❌ More technical knowledge needed

**Cost:** $12-40/month for VPS

---

## Option 3: Docker on VPS

Deploy using Docker Compose on a VPS.

### Step 1: Set Up VPS
Follow steps 1-2 from Option 2.

### Step 2: Install Docker

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
apt-get install -y docker-compose-plugin

# Add user to docker group
usermod -aG docker $USER
```

### Step 3: Deploy LMS

```bash
# Clone or upload your LMS code
git clone https://github.com/frappe/lms.git
cd lms/docker

# Edit docker-compose.yml if needed
# Then start
docker compose up -d
```

### Step 4: Set Up Nginx and SSL
Follow steps 7-8 from Option 2.

**Pros:**
- ✅ Easy deployment
- ✅ Consistent environment
- ✅ Easy updates

**Cons:**
- ❌ Still need server management
- ❌ Docker knowledge helpful

---

## Option 4: AWS/GCP/Azure (Enterprise)

For larger deployments with auto-scaling.

### AWS Elastic Beanstalk
- Managed platform
- Auto-scaling
- Load balancing
- More complex setup

### Google Cloud Run
- Container-based
- Auto-scaling
- Pay per use

### Azure App Service
- Managed platform
- Easy deployment
- Integrated with Azure services

**Best for:** Large organizations, high traffic, enterprise needs

---

## Production Checklist

Before going live:

### Security
- [ ] Change default passwords
- [ ] Set up SSL/HTTPS
- [ ] Configure firewall (only ports 80, 443, 22)
- [ ] Set up regular backups
- [ ] Enable 2FA for admin accounts
- [ ] Review user permissions

### Performance
- [ ] Enable Redis caching
- [ ] Set up CDN for static assets (optional)
- [ ] Configure database optimization
- [ ] Set up monitoring

### Backup
- [ ] Automated daily backups
- [ ] Off-site backup storage
- [ ] Test restore procedure

### Monitoring
- [ ] Set up uptime monitoring
- [ ] Error logging (Sentry, etc.)
- [ ] Performance monitoring
- [ ] Disk space alerts

### Domain & DNS
- [ ] Point domain to server
- [ ] SSL certificate installed
- [ ] Email configured (for notifications)

---

## Recommended Setup for Ethics Labs

### For Quick Launch (1-2 hours)
**Use Frappe Cloud**
- Fastest to deploy
- No server management
- Automatic SSL and backups

### For Full Control (1 day setup)
**Use DigitalOcean/Linode VPS**
- 4GB RAM droplet
- Ubuntu 22.04
- Follow Option 2 steps
- Custom domain
- Full customization

### Estimated Costs

**Frappe Cloud:**
- Starter: $5/month
- Standard: $25/month
- Professional: $50/month

**VPS (DigitalOcean):**
- Basic: $12/month (2GB RAM)
- Recommended: $24/month (4GB RAM)
- Domain: $10-15/year

**Total (VPS + Domain):**
- ~$25-30/month

---

## Step-by-Step: DigitalOcean Deployment

### 1. Create Droplet
- Ubuntu 22.04
- 4GB RAM / 2 vCPUs
- $24/month
- Add SSH key

### 2. Initial Setup (15 min)
```bash
ssh root@your-server-ip
# Follow Option 2, Step 2-4
```

### 3. Install Bench & LMS (20 min)
```bash
# Follow Option 2, Step 5-6
```

### 4. Configure Nginx & SSL (15 min)
```bash
# Follow Option 2, Step 7-8
```

### 5. Point Domain (5 min)
- Add A record at domain registrar
- Wait for DNS propagation

### 6. Configure Site (10 min)
- Login to your site
- Set up branding
- Create courses

**Total Time:** ~1-2 hours

---

## Maintenance

### Regular Tasks

**Weekly:**
- Check disk space
- Review error logs
- Monitor performance

**Monthly:**
- Update Frappe and apps
- Review security
- Test backups

**Commands:**
```bash
# Update Frappe
bench update

# Backup
bench --site your-site backup --with-files

# Check status
bench --site your-site doctor
```

---

## Need Help?

- **Frappe Cloud Support**: https://frappecloud.com/support
- **Frappe Forum**: https://discuss.frappe.io
- **Documentation**: https://frappeframework.com/docs

---

**Recommended: Start with Frappe Cloud for easiest deployment, or VPS for full control!**
