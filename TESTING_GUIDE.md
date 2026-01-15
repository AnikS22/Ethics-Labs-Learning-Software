# Testing Guide - Ethics Lab LMS

This guide will help you test the LMS locally to see how everything looks, including certificates, courses, and branding.

## Quick Start Testing (Docker - Easiest)

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
- Start the server

### Step 3: Access the Application

1. Wait 2-3 minutes for setup to complete
2. Visit: `http://localhost:8000`
3. You'll see the setup wizard

### Step 4: Complete Setup Wizard

1. Fill in:
   - **Site Name**: `ethicslabs.localhost` (or any name)
   - **Database**: Leave default
   - **Admin Email**: Your email
   - **Admin Password**: Create a password
   - **Country**: Your country
   - **Language**: English

2. Click **Complete Setup**

### Step 5: Login

- **URL**: `http://localhost:8000` or `http://ethicslabs.localhost:8000`
- **Username**: Administrator (or the email you used)
- **Password**: The password you set

### Step 6: Install LMS App

1. Go to **Apps** (`/app`)
2. Find **LMS** in the list
3. Click **Install**
4. Wait for installation to complete

### Step 7: Create Test Courses

**Option A: Use the Setup Script**

```bash
# From bench directory (if using bench) or via console
bench --site ethicslabs.localhost console
```

Then:
```python
from lms.setup_courses import setup_ethics_lab_courses
setup_ethics_lab_courses()
```

**Option B: Create Manually**

1. Go to **LMS Course** (`/app/lms-course`)
2. Click **New**
3. Create a test course (see COURSE_SETUP_GUIDE.md)

### Step 8: Test Certificate Generation

1. **Create a test student**:
   - Go to **User** (`/app/user`)
   - Click **New**
   - Create a user (e.g., `student@test.com`)
   - Set password

2. **Enroll in course**:
   - Logout and login as the student
   - Go to `/courses`
   - Enroll in your test course

3. **Complete course** (or manually issue certificate):
   - As Administrator, go to **LMS Certificate** (`/app/lms-certificate`)
   - Click **New**
   - Select:
     - **Member**: Your test student
     - **Course**: Your test course
     - **Template**: Certificate
   - Save

4. **View certificate**:
   - The certificate URL will be: `/courses/[course-name]/[certificate-id]`
   - Or go to the student's profile → Certificates

### Step 9: View Frontend

1. **Student View**:
   - Logout
   - Visit: `http://localhost:8000/lms` or `http://ethicslabs.localhost:8000/lms`
   - You'll see the public-facing LMS interface

2. **Test Course Pages**:
   - Browse courses at `/courses`
   - View course details
   - Check certificate design

## Testing Specific Features

### Test Certificate Design

1. **Generate a test certificate** (see Step 8 above)
2. **View the certificate**:
   - Open in browser
   - Check that it shows:
     - "The Ethics Lab" in blackletter font
     - Decorative corner elements (neural network, brain, arms)
     - Proper colors (blue, orange, red)
     - Signature section

3. **Download as PDF**:
   - Click download/print
   - Verify PDF looks correct
   - Check landscape orientation

### Test Course Structure

1. **View course list**:
   - Go to `/courses`
   - See if courses display correctly
   - Check course cards

2. **View course details**:
   - Click on a course
   - Check chapters and lessons display
   - Verify navigation works

3. **Test lesson viewing**:
   - Enroll in a course
   - Navigate through lessons
   - Check content displays properly

### Test Branding

1. **Check site title**:
   - Browser tab should show "Ethics Labs"
   - Check page titles

2. **Check colors**:
   - Buttons should be bright blue (#0066FF)
   - Links should be blue
   - Check certificate colors

3. **Check logos** (if replaced):
   - Verify logos appear correctly
   - Check favicon

## Alternative: Local Development Setup

If you prefer not to use Docker:

### Step 1: Install Bench

```bash
# Install Python dependencies
sudo apt-get update
sudo apt-get install -y python3-dev python3-pip python3-venv
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
mkdir ~/frappe-bench
cd ~/frappe-bench
bench init --frappe-branch version-14 frappe-bench
cd frappe-bench
```

### Step 3: Create Site

```bash
bench new-site ethicslabs.localhost
bench --site ethicslabs.localhost add-to-hosts
```

### Step 4: Install LMS

```bash
bench get-app lms /path/to/your/lms/directory
bench --site ethicslabs.localhost install-app lms
```

### Step 5: Build Frontend

```bash
cd apps/lms
yarn install
yarn build
```

### Step 6: Start Server

```bash
cd ~/frappe-bench/frappe-bench
bench start
```

### Step 7: Access

- Visit: `http://ethicslabs.localhost:8000`
- Login with Administrator credentials

## Testing Checklist

### Certificate Testing
- [ ] Certificate generates correctly
- [ ] "The Ethics Lab" title displays in correct font
- [ ] Decorative elements appear in corners
- [ ] Colors match design (blue, orange, red)
- [ ] Signature section displays correctly
- [ ] PDF download works
- [ ] Landscape orientation is correct
- [ ] Text is readable and properly formatted

### Course Testing
- [ ] Courses can be created
- [ ] Chapters and lessons display correctly
- [ ] Course content renders properly
- [ ] Navigation between lessons works
- [ ] Enrollment process works
- [ ] Progress tracking functions

### Branding Testing
- [ ] Site title shows "Ethics Labs"
- [ ] Colors match theme (blue, orange, red)
- [ ] Buttons use correct colors
- [ ] Links are styled correctly
- [ ] Logo displays (if replaced)

### UI/UX Testing
- [ ] Pages load correctly
- [ ] Responsive design works on mobile
- [ ] Forms function properly
- [ ] Navigation is intuitive
- [ ] Error messages display correctly

## Common Issues and Solutions

### Issue: Certificate not generating

**Solution**:
- Check that course has "Enable Certification" enabled
- Verify student has completed course requirements
- Check certificate template is set correctly

### Issue: Frontend not loading

**Solution**:
- Ensure you've built the frontend: `cd apps/lms && yarn build`
- Check browser console for errors
- Verify assets are being served

### Issue: Courses not appearing

**Solution**:
- Check courses are published
- Verify you're logged in as appropriate user
- Check course visibility settings

### Issue: Docker containers not starting

**Solution**:
- Check Docker is running: `docker ps`
- Check logs: `docker-compose logs`
- Try rebuilding: `docker-compose down && docker-compose up -d`

### Issue: Port already in use

**Solution**:
- Change port in docker-compose.yml
- Or stop other services using port 8000

## Quick Test Commands

### Check if server is running
```bash
curl http://localhost:8000
```

### View Docker logs
```bash
cd lms/docker
docker-compose logs -f
```

### Stop Docker containers
```bash
cd lms/docker
docker-compose down
```

### Reset everything (Docker)
```bash
cd lms/docker
docker-compose down --volumes
docker-compose up -d
```

### Access bench console
```bash
bench --site ethicslabs.localhost console
```

## Viewing Certificates

### Method 1: Through Student Profile
1. Login as student
2. Go to profile
3. Click "Certificates" tab
4. View certificate

### Method 2: Direct URL
1. Get certificate ID from LMS Certificate doctype
2. Visit: `/courses/[course-name]/[certificate-id]`

### Method 3: Download PDF
1. View certificate in browser
2. Use browser print function
3. Save as PDF

## Testing on Different Devices

### Desktop Browser
- Chrome/Edge (recommended)
- Firefox
- Safari

### Mobile Testing
1. Find your local IP: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)
2. Access from mobile: `http://[your-ip]:8000`
3. Test responsive design

## Next Steps After Testing

Once you've verified everything works:

1. **Customize Content**: Add actual course content
2. **Replace Logos**: Add your Ethics Lab logos
3. **Configure Settings**: Set up email, payments, etc.
4. **Add More Courses**: Create additional courses as needed
5. **Deploy to Production**: Follow DEPLOYMENT_GUIDE.md

## Need Help?

- **Certificate Issues**: See CERTIFICATE_DESIGN_GUIDE.md
- **Course Setup**: See COURSE_SETUP_GUIDE.md
- **Deployment**: See DEPLOYMENT_GUIDE.md
- **Branding**: See ETHICS_LABS_BRANDING.md

---

**Happy Testing!** 🚀
