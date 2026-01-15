# Course Setup Guide

This guide explains how to set up the two main Ethics Lab courses in your LMS.

## Overview

Ethics Lab offers two main courses:

1. **AI Ethics** - Understanding AI ethics and philosophical questions
2. **Ethical Creation of AI** - Learning how to make and develop AI ethically

## Option 1: Automated Setup (Recommended)

### Using the Python Script

A Python script is provided to automatically create both courses with their complete structure.

#### Step 1: Ensure You're in Bench Directory

```bash
cd ~/frappe-bench
```

#### Step 2: Run the Setup Script

**Option A: Using bench execute (Recommended)**

```bash
bench --site your-site-name console
```

Then in the Python console:
```python
from lms.setup_courses import setup_ethics_lab_courses
setup_ethics_lab_courses()
```

**Option B: Direct execution**

```bash
cd apps/lms
bench --site your-site-name execute lms.setup_courses.setup_ethics_lab_courses
```

**Option C: Using bench console**

```bash
bench --site your-site-name console
```

Then:
```python
exec(open('apps/lms/setup_courses.py').read())
setup_ethics_lab_courses()
```

#### Step 3: Verify Courses

1. Log into your Frappe site
2. Navigate to **LMS Course** (`/app/lms-course`)
3. You should see both courses created:
   - "AI Ethics"
   - "Ethical Creation of AI"

#### Step 4: Add Instructors

1. Open each course
2. Go to the **Instructors** section
3. Add instructor users (you'll need to create instructor users first if they don't exist)

#### Step 5: Add Course Content

The script creates the course structure (chapters and lessons) but with placeholder content. You'll need to:

1. Open each lesson
2. Add the actual content (text, videos, etc.)
3. Create quizzes and assignments as needed

## Option 2: Manual Setup

### Creating AI Ethics Course

#### Step 1: Create the Course

1. Go to **LMS Course** (`/app/lms-course`)
2. Click **New**
3. Fill in:
   - **Title**: AI Ethics
   - **Short Introduction**: "Understand the ethical dimensions of artificial intelligence through philosophical inquiry and critical analysis."
   - **Description**: (See COURSE_STRUCTURES.md for full description)
   - **Tags**: AI Ethics, Philosophy, Ethics, Critical Thinking, Social Impact
   - **Published**: ✓
   - **Enable Certification**: ✓
   - **Paid Course**: (uncheck for free course)

4. Add at least one instructor
5. Save

#### Step 2: Create Chapters

For each chapter listed in COURSE_STRUCTURES.md:

1. In the course, go to the **Chapters** section
2. Click **Add Row**
3. Create a new **Course Chapter**:
   - **Title**: (e.g., "Foundations of AI Ethics")
   - **Course**: (select your AI Ethics course)
   - Save

#### Step 3: Create Lessons

For each lesson in a chapter:

1. Go to **Course Lesson** (`/app/course-lesson`)
2. Click **New**
3. Fill in:
   - **Title**: (e.g., "What is AI Ethics?")
   - **Chapter**: (select the appropriate chapter)
   - **Course**: (will auto-fill from chapter)
   - **Body**: Add your lesson content (markdown supported)
4. Save

5. Go back to the chapter and add the lesson to the **Lessons** table

### Creating Ethical Creation of AI Course

Follow the same steps as above, using the structure from COURSE_STRUCTURES.md for the "Ethical Creation of AI" course.

### Linking Related Courses

1. Open the "AI Ethics" course
2. Go to **Related Courses** section
3. Add "Ethical Creation of AI" course
4. Do the same in reverse for the "Ethical Creation of AI" course

## Course Configuration

### Recommended Settings

Both courses should have:

- **Published**: Yes
- **Enable Certification**: Yes
- **Completion Certificate**: Yes
- **Paid Course**: Configure as needed (free recommended for accessibility)
- **Self-Learning**: Enabled
- **Category**: Create an "Ethics Lab" category if desired

### Instructors

Each course should have:
- At least one instructor with AI ethics expertise
- At least one instructor with technical AI/ML expertise (for Ethical Creation course)
- Diverse backgrounds recommended

To add instructors:

1. Ensure users exist in the system
2. In the course, go to **Instructors** section
3. Add instructor users

### Certificates

Both courses are configured to issue certificates. The certificate will show:
- Course title (e.g., "Certificate of AI Ethics")
- Student name
- Ethics Lab branding
- Signatures (Anik Sahai and Michael Gomez)

## Content Development

### Lesson Content

Each lesson should include:

1. **Written Content** (Body field):
   - Overview
   - Learning objectives
   - Main content
   - Key takeaways
   - Further reading/resources

2. **Videos** (optional):
   - Add YouTube links or video embeds
   - Use the **YouTube** field in lessons

3. **Quizzes** (optional):
   - Create quizzes in **LMS Quiz**
   - Link to lessons using **Quiz ID** field

4. **Assignments** (optional):
   - Create assignments in **LMS Assignment**
   - Link to lessons

### Quizzes

Create quizzes to assess understanding:

1. Go to **LMS Quiz** (`/app/lms-quiz`)
2. Create quiz with questions
3. Link to lessons using the Quiz ID

### Assignments

Create practical assignments:

1. Go to **LMS Assignment** (`/app/lms-assignment`)
2. Create assignment with instructions
3. Students can submit files/documents

## Course Structure Reference

See `COURSE_STRUCTURES.md` for the complete structure of both courses, including:
- All chapters and their descriptions
- All lessons within each chapter
- Learning objectives
- Content suggestions

## Testing

After setting up courses:

1. **Test Enrollment**:
   - Create a test student account
   - Enroll in a course
   - Verify course structure displays correctly

2. **Test Content**:
   - Navigate through chapters and lessons
   - Verify content displays properly
   - Test quizzes and assignments

3. **Test Certification**:
   - Complete a course as a test student
   - Verify certificate is generated
   - Check certificate design matches Ethics Lab branding

## Customization

### Course Descriptions

You can customize:
- Course descriptions
- Chapter descriptions
- Lesson content
- Quiz questions
- Assignment requirements

### Adding More Courses

To add additional courses:
1. Follow the same structure
2. Reference COURSE_STRUCTURES.md for formatting
3. Update related courses as needed

## Troubleshooting

### Courses Not Appearing

- Check if courses are published
- Verify you're logged in as a user with appropriate permissions
- Check course visibility settings

### Chapters/Lessons Not Showing

- Ensure chapters are added to the course's Chapters table
- Ensure lessons are added to the chapter's Lessons table
- Check that lessons are linked to the correct chapter

### Certificates Not Generating

- Verify "Enable Certification" is checked
- Ensure student has completed all course requirements
- Check certificate template is configured

## Next Steps

After setting up courses:

1. **Add Content**: Populate lessons with actual content
2. **Create Assessments**: Add quizzes and assignments
3. **Add Media**: Include videos, images, and other resources
4. **Test Everything**: Verify all functionality works
5. **Launch**: Make courses available to students

## Support

For questions about:
- Course structure: See COURSE_STRUCTURES.md
- Certificate design: See CERTIFICATE_DESIGN_GUIDE.md
- General setup: See DEPLOYMENT_GUIDE.md

---

**Courses are ready to be populated with content!**
