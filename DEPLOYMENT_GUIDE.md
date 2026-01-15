# Ethics Labs LMS Deployment Guide

This guide will help you deploy the Ethics Labs Learning Management System.

## Prerequisites

- Python 3.8+ or Docker
- Node.js 16+ and Yarn (for frontend development)
- MySQL/MariaDB or PostgreSQL database
- Basic knowledge of Linux server administration

## Option 1: Docker Deployment (Recommended for Quick Start)

### Step 1: Navigate to Docker Directory

```bash
cd lms/docker
```

### Step 2: Start the Containers

```bash
docker-compose up -d
```

This will:
- Set up MariaDB database
- Install Frappe Framework
- Install LMS app
- Set up the frontend

### Step 3: Access the Application

1. Visit `http://localhost:8000` (or your server IP)
2. Complete the setup wizard
3. Default credentials:
   - Username: `Administrator`
   - Password: `admin`

### Step 4: Configure Ethics Labs Branding

1. Log in as Administrator
2. Go to **Website Settings** (`/app/website-settings`)
   - Set **App Name**: "Ethics Labs"
   - Upload your **Favicon** and **Banner Image**
3. Go to **LMS Settings** (`/app/lms-settings`)
   - Configure meta description, keywords, and images
4. Replace logo files in `lms/public/images/` with your Ethics Labs logo

### Step 5: Create Your First Course

1. Navigate to **Courses** (`/app/course`)
2. Click **New**
3. Fill in course details:
   - Title
   - Description
   - Image
   - Chapters and Lessons
4. Enable certification if needed
5. Publish the course

## Option 2: Production Deployment (Self-Hosting)

### Step 1: Install Bench

Bench is the Frappe Framework installation tool.

```bash
# Install Python dependencies
sudo apt-get update
sudo apt-get install -y python3-dev python3-pip python3-venv

# Install other dependencies
sudo apt-get install -y git curl mariadb-server mariadb-client
sudo apt-get install -y redis-server
sudo apt-get install -y nginx supervisor

# Install Node.js and Yarn
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -y -g yarn

# Install Bench
sudo pip3 install frappe-bench
```

### Step 2: Initialize Bench

```bash
# Create a bench directory
mkdir ~/frappe-bench
cd ~/frappe-bench

# Initialize bench
bench init --frappe-branch version-14 frappe-bench

# Enter the bench directory
cd frappe-bench
```

### Step 3: Create a New Site

```bash
# Create site (replace with your domain)
bench new-site ethicslabs.localhost

# Add site to hosts file (for local development)
bench --site ethicslabs.localhost add-to-hosts
```

### Step 4: Install LMS App

```bash
# Get the LMS app
bench get-app lms /path/to/your/lms/directory

# Install the app to your site
bench --site ethicslabs.localhost install-app lms
```

### Step 5: Build Frontend Assets

```bash
# Navigate to app directory
cd apps/lms

# Install frontend dependencies
yarn install

# Build frontend
yarn build
```

### Step 6: Start the Development Server

```bash
# From bench directory
bench start
```

Access at `http://ethicslabs.localhost:8000`

### Step 7: Production Setup

For production, you'll need to:

1. **Set up Nginx** as a reverse proxy
2. **Configure Supervisor** to manage processes
3. **Set up SSL** certificates (Let's Encrypt)
4. **Configure backups**

Example Nginx configuration:

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

## Option 3: Managed Hosting (Frappe Cloud)

Frappe Cloud offers managed hosting for Frappe applications:

1. Sign up at [frappecloud.com](https://frappecloud.com)
2. Create a new site
3. Install the LMS app
4. Configure your domain

## Post-Deployment Checklist

- [ ] Replace logo files with Ethics Labs branding
- [ ] Configure Website Settings with Ethics Labs information
- [ ] Set up LMS Settings (meta tags, descriptions)
- [ ] Customize certificate template colors/styling
- [ ] Create your first course
- [ ] Test certificate generation
- [ ] Set up email server for notifications
- [ ] Configure backups
- [ ] Set up monitoring
- [ ] Review security settings

## Certificate Configuration

To enable certificates:

1. Go to **LMS Course** → Select your course
2. Enable **Enable Certification** checkbox
3. Configure certificate settings:
   - Paid Certificate (if applicable)
   - Certificate Template
   - Expiry Date (optional)

Certificates are automatically generated when:
- A student completes all course requirements
- An instructor manually issues a certificate

## Course Structure

The LMS uses a 3-level hierarchy:

1. **Course** - Top-level container
   - Contains course metadata, pricing, instructors
   - Can have multiple chapters

2. **Chapter** - Groups lessons
   - Organizes lessons into logical sections
   - Each course can have multiple chapters

3. **Lesson** - Individual learning content
   - Can contain text, videos, quizzes, assignments
   - Belongs to a chapter

## Troubleshooting

### Frontend not loading
- Ensure you've run `yarn build` in the lms directory
- Check that assets are being served correctly

### Database connection errors
- Verify database credentials in `site_config.json`
- Ensure MariaDB/MySQL is running

### Certificate not generating
- Check that course has "Enable Certification" enabled
- Verify student has completed all requirements
- Check certificate template is configured

## Support

For issues specific to Ethics Labs customization, refer to `ETHICS_LABS_BRANDING.md`.

For Frappe Framework issues, see:
- [Frappe Documentation](https://frappeframework.com/docs)
- [Frappe Forum](https://discuss.frappe.io)

## Security Considerations

1. **Change default passwords** immediately
2. **Set up SSL/TLS** for production
3. **Configure firewall** rules
4. **Regular backups** of database and files
5. **Keep Frappe and apps updated**
6. **Review user permissions** regularly

## Maintenance

### Updating the App

```bash
# From bench directory
bench update --pull
bench migrate
bench build --app lms
```

### Backing Up

```bash
# Backup database and files
bench --site your-site-name backup --with-files
```

### Restoring

```bash
# Restore from backup
bench --site your-site-name restore /path/to/backup
```
