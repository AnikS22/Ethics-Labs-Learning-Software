# Quick Test Guide - See Your LMS in Action

## Fastest Way to Test (5 minutes)

### Step 1: Start Docker

```bash
cd lms/docker
docker-compose up -d
```

Wait 2-3 minutes for everything to start.

### Step 2: Access the Site

Open your browser and go to:
```
http://localhost:8000
```

### Step 3: Complete Setup

1. Fill in the setup wizard:
   - Site name: `ethicslabs.localhost`
   - Email: Your email
   - Password: Create a password
   - Click "Complete Setup"

2. Login:
   - Username: Administrator (or your email)
   - Password: The password you created

### Step 4: Install LMS App

1. Go to: `http://localhost:8000/app`
2. Find "LMS" in the app list
3. Click "Install"
4. Wait for installation

### Step 5: Create a Test Certificate (See It Immediately!)

1. **Create a test course**:
   - Go to: `http://localhost:8000/app/lms-course`
   - Click "New"
   - Title: "Test Course"
   - Short Introduction: "A test course"
   - Description: "Test description"
   - Check "Published"
   - Check "Enable Certification"
   - Save

2. **Create a test student**:
   - Go to: `http://localhost:8000/app/user`
   - Click "New"
   - Email: `student@test.com`
   - Full Name: "Test Student"
   - Set a password
   - Save

3. **Generate a certificate**:
   - Go to: `http://localhost:8000/app/lms-certificate`
   - Click "New"
   - Member: `student@test.com`
   - Course: Your test course
   - Template: Certificate
   - Issue Date: Today
   - Save

4. **View the certificate**:
   - The certificate will have a URL like: `/courses/[course-name]/[certificate-id]`
   - Or go to: `http://localhost:8000/lms` and login as the student
   - Navigate to their profile → Certificates

### Step 6: View the Frontend

Visit the public-facing LMS:
```
http://localhost:8000/lms
```

You'll see:
- Course listings
- Your test course
- Student interface

## What to Check

### ✅ Certificate Design
- [ ] "The Ethics Lab" appears in decorative font
- [ ] Corner decorations visible (neural network, brain, arms)
- [ ] Colors are correct (blue borders, orange signatures)
- [ ] Signature section shows names
- [ ] Landscape layout looks good

### ✅ Course Pages
- [ ] Courses display on `/courses`
- [ ] Course details page works
- [ ] Chapters and lessons show correctly

### ✅ Branding
- [ ] Site title shows "Ethics Labs"
- [ ] Colors match theme
- [ ] Buttons are blue

## Quick Commands

### Stop the server
```bash
cd lms/docker
docker-compose down
```

### Restart
```bash
cd lms/docker
docker-compose up -d
```

### View logs
```bash
cd lms/docker
docker-compose logs -f
```

### Reset everything
```bash
cd lms/docker
docker-compose down --volumes
docker-compose up -d
```

## Troubleshooting

**Can't access localhost:8000?**
- Wait a bit longer (first startup takes time)
- Check Docker is running: `docker ps`
- Check logs: `docker-compose logs`

**Setup wizard not showing?**
- Clear browser cache
- Try incognito/private window
- Check if port 8000 is already in use

**LMS app not in list?**
- Make sure you're in the right directory
- Check docker logs for errors
- Try restarting: `docker-compose restart`

## Next: Set Up Your Courses

Once you've tested the basics:

1. **Create the two main courses**:
   ```bash
   # In bench console
   from lms.setup_courses import setup_ethics_lab_courses
   setup_ethics_lab_courses()
   ```

2. **Add content to lessons**

3. **Test full student journey**

See `TESTING_GUIDE.md` for more detailed testing instructions.

---

**That's it! You should now see your Ethics Lab LMS running locally.** 🎉
