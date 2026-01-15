# Ethics Labs Branding Guide

This document outlines all the branding changes made to customize Frappe LMS for Ethics Labs.

## Changes Made

### 1. Application Name
- **File**: `lms/www/lms.py`
  - Changed default app name from "Frappe Learning" to "Ethics Labs"
  - This appears in the browser title and meta tags

### 2. Package Information
- **File**: `package.json`
  - Updated description to "Ethics Labs - Learning Management System"

- **File**: `setup.py`
  - Updated description to "Ethics Labs - Learning Management System"

### 3. README
- **File**: `README.md`
  - Updated title and description to reflect Ethics Labs branding

### 4. Certificate Template
- **File**: `lms/lms/print_format/certificate/certificate.json`
  - Updated certificate header from "LMS Certificate" to "Ethics Labs Certificate"

## Manual Steps Required

### 1. Logo Replacement
Replace the logo file at:
- `lms/public/images/lms-logo.png` with your Ethics Labs logo

You may also want to update:
- `lms/public/images/lms.png`
- Any other logo references in the frontend

### 2. Website Settings Configuration
After installation, configure in Frappe:
1. Go to **Website Settings** (`/app/website-settings`)
2. Set **App Name** to "Ethics Labs"
3. Upload your **Favicon** and **Banner Image** (Ethics Labs branding)

### 3. LMS Settings Configuration
1. Go to **LMS Settings** (`/app/lms-settings`)
2. Configure:
   - Meta Description
   - Meta Keywords
   - Meta Image
   - Certification Email Template (optional)

### 4. Color Scheme Customization
The primary color is defined in CSS variables. To customize:
- Edit `lms/public/css/style.css`
- Look for `--primary-color` and `--primary` variables
- Update to match Ethics Labs brand colors

### 5. Certificate Styling
The certificate template uses:
- Border color: `#0089FF` (blue)
- You can customize this in the certificate print format CSS

To customize:
1. Go to **Print Format** → **Certificate** (`/app/print-format/certificate`)
2. Edit the CSS in the format
3. Update colors, fonts, and layout as needed

## Course Structure

The LMS uses a 3-level hierarchy:
1. **Course** - Top level container
2. **Chapter** - Groups lessons within a course
3. **Lesson** - Individual learning content

This structure is already in place and can be customized through the admin interface.

## Next Steps

1. **Install the application** (see deployment guide)
2. **Replace logos** with Ethics Labs branding
3. **Configure Website Settings** with Ethics Labs information
4. **Customize colors** in CSS files
5. **Test certificate generation** to ensure branding appears correctly
6. **Create your first course** and test the full workflow

## Hosting

See `DEPLOYMENT_GUIDE.md` for detailed hosting instructions.
