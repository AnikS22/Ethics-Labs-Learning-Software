# Ethics Labs LMS - Quick Start Guide

## What Has Been Done

✅ **Branding Updated**
- Changed application name from "Frappe Learning" to "Ethics Labs" throughout the codebase
- Updated package descriptions and README
- Modified certificate templates to show "Ethics Labs Certificate"

✅ **Color Scheme Applied**
- Updated to Ethics Lab theme colors:
  - **Bright Blue** (#0066FF) - Primary color
  - **Orange/Gold** (#FF8C00 / #FFD700) - Secondary color
  - **Red** (#FF4444) - Accent color
  - **Black** (#000000) - Text color
- Certificate borders and styling updated with new colors
- Created comprehensive color scheme CSS file

✅ **Course Structure**
- The LMS already has a perfect 3-level hierarchy:
  - **Course** → **Chapter** → **Lesson**
- This structure is ready to use - no restructuring needed!

✅ **Certificate System**
- Certificate generation is already configured
- Template updated with Ethics Labs branding
- Certificates are automatically issued when students complete courses

✅ **Documentation Created**
- `ETHICS_LABS_BRANDING.md` - Complete branding guide
- `DEPLOYMENT_GUIDE.md` - Step-by-step deployment instructions

## Next Steps

### 1. Replace Logo Files

You need to replace the logo files with your Ethics Labs logo:

```bash
# Replace these files in lms/lms/public/images/
- lms-logo.png  (main logo)
- lms.png       (alternative logo)
```

### 2. Choose Your Deployment Method

**Option A: Docker (Easiest - Recommended for Testing)**
```bash
cd lms/docker
docker-compose up -d
```
Then visit `http://localhost:8000`

**Option B: Production Deployment**
Follow the detailed instructions in `DEPLOYMENT_GUIDE.md`

### 3. Configure After Installation

Once installed, log in as Administrator and:

1. **Website Settings** (`/app/website-settings`)
   - Set App Name: "Ethics Labs"
   - Upload your favicon and banner image

2. **LMS Settings** (`/app/lms-settings`)
   - Configure meta description
   - Set meta keywords
   - Upload meta image

3. **Customize Colors** (Optional)
   - Colors are already set to Ethics Lab theme (Bright Blue, Orange, Red)
   - See `ETHICS_LAB_THEME_GUIDE.md` for full color palette
   - To customize further, edit `lms/public/css/style.css` or use `ETHICS_LAB_COLOR_SCHEME.css`

### 4. Create Your First Course

1. Go to **Courses** (`/app/course`)
2. Click **New**
3. Fill in:
   - Title: "Introduction to Ethics"
   - Description
   - Image
   - Enable Certification (if you want certificates)
4. Add Chapters
5. Add Lessons to each Chapter
6. Publish

### 5. Test Certificate Generation

1. Enroll a test student in your course
2. Complete all lessons
3. Certificate should be automatically generated
4. View at `/courses/[course-name]/[certificate-id]`

## File Structure Overview

```
lms/
├── lms/                          # Backend Python code
│   ├── www/                      # Web routes
│   │   └── lms.py               # Main web handler (✅ Updated)
│   ├── public/                   # Static assets
│   │   ├── images/              # Logos (⚠️ Need to replace)
│   │   └── css/                 # Styles (can customize)
│   ├── print_format/            # Certificate templates (✅ Updated)
│   └── lms/doctype/             # Data models
│       ├── lms_course/          # Course structure
│       ├── course_chapter/      # Chapters
│       └── course_lesson/      # Lessons
├── frontend/                     # Vue.js frontend
│   └── src/
│       └── pages/              # Frontend pages
├── docker/                       # Docker setup files
├── ETHICS_LABS_BRANDING.md      # Branding guide (✅ New)
├── DEPLOYMENT_GUIDE.md         # Deployment guide (✅ New)
└── QUICK_START.md              # This file (✅ New)
```

## Key Features Available

✅ **Course Management**
- Create courses with chapters and lessons
- Upload videos, documents, and content
- Set pricing (free or paid)
- Enable/disable self-learning

✅ **Pre-Configured Courses**
- **AI Ethics**: Understanding AI ethics and philosophical questions (8 chapters, 28 lessons)
- **Ethical Creation of AI**: Learning how to make and develop AI ethically (10 chapters, 33 lessons)
- See `COURSE_SETUP_GUIDE.md` for setup instructions

✅ **Student Management**
- User registration and profiles
- Enrollment tracking
- Progress monitoring

✅ **Certification**
- Automatic certificate generation
- Customizable certificate templates
- Certificate expiry dates (optional)

✅ **Assessments**
- Quizzes (multiple choice, single choice, open-ended)
- Assignments (file submissions)
- Programming exercises

✅ **Live Classes**
- Schedule live classes
- Zoom integration
- Class timetables

✅ **Analytics**
- Enrollment statistics
- Course completion rates
- Student progress tracking

## Support & Resources

- **Branding Guide**: See `ETHICS_LABS_BRANDING.md`
- **Deployment Help**: See `DEPLOYMENT_GUIDE.md`
- **Frappe Docs**: https://frappeframework.com/docs
- **LMS Documentation**: https://docs.frappe.io/learning

## Important Notes

⚠️ **Before Going Live:**
1. Change default Administrator password
2. Set up SSL/HTTPS
3. Configure email server for notifications
4. Set up regular backups
5. Review security settings

⚠️ **Logo Replacement:**
The system will work with default logos, but you should replace them with your Ethics Labs branding for a professional appearance.

## Quick Commands Reference

```bash
# Docker - Start
cd lms/docker && docker-compose up -d

# Docker - Stop
docker-compose down

# Docker - Reset (clears all data)
docker-compose down --volumes && docker-compose up -d

# Bench - Start development server
bench start

# Bench - Create new site
bench new-site your-site-name

# Bench - Install app
bench --site your-site-name install-app lms

# Bench - Build frontend
cd apps/lms && yarn build
```

## Testing Your Setup

**Want to see what it looks like?** See `QUICK_TEST.md` for the fastest way to test locally!

Quick test steps:
1. `cd lms/docker && docker-compose up -d`
2. Visit `http://localhost:8000`
3. Complete setup wizard
4. Install LMS app
5. Create a test certificate to see the design!

For detailed testing instructions, see `TESTING_GUIDE.md`.

---

**You're all set!** Start by deploying with Docker to test, then move to production when ready.
