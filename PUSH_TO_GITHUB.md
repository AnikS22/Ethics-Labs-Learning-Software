# Push to GitHub - Ethics Labs Learning Software

## Quick Commands

### Step 1: Create GitHub Repository

**Option A: Using GitHub Website**
1. Go to https://github.com/new
2. Repository name: `Ethics-Labs-Learning-Software`
3. Description: "Ethics Labs Learning Management System - Customized LMS"
4. Choose Public or Private
5. **Don't** initialize with README (we already have files)
6. Click "Create repository"

**Option B: Using GitHub CLI (if installed)**
```bash
gh repo create Ethics-Labs-Learning-Software --public --description "Ethics Labs Learning Management System"
```

### Step 2: Add Remote and Push

```bash
cd "/Users/aniksahai/Desktop/Ethics Lab Learning Software/lms"

# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/Ethics-Labs-Learning-Software.git

# Or if you prefer SSH:
# git remote add origin git@github.com:YOUR_USERNAME/Ethics-Labs-Learning-Software.git

# Add all files
git add .

# Commit changes
git commit -m "Initial commit: Ethics Labs LMS with custom branding, courses, and certificates"

# Push to GitHub
git push -u origin main
```

### If Main Branch is Different

If your default branch is `master` instead of `main`:

```bash
# Rename branch to main
git branch -M main

# Then push
git push -u origin main
```

## What Will Be Pushed

All your customizations:
- ✅ Ethics Labs branding
- ✅ Custom color scheme (#0099ff cyan blue)
- ✅ Certificate design with decorative elements
- ✅ Course structures (AI Ethics & Ethical Creation of AI)
- ✅ Setup scripts
- ✅ Documentation

## Important Notes

### Files to Exclude (Already in .gitignore)
- `node_modules/`
- `.env` files
- Database files
- Log files
- Build artifacts

### Sensitive Information
Before pushing, make sure you haven't committed:
- Passwords
- API keys
- Database credentials
- Personal information

### Large Files
The repository includes:
- Docker images (handled by Docker)
- Some image files
- All should be fine for GitHub

## After Pushing

Your repository will be available at:
```
https://github.com/YOUR_USERNAME/Ethics-Labs-Learning-Software
```

## Future Updates

To push future changes:
```bash
git add .
git commit -m "Description of changes"
git push
```
