#!/bin/bash

# Script to push Ethics Labs LMS to GitHub
# Run this after creating the repository on GitHub

echo "🚀 Setting up GitHub repository for Ethics Labs Learning Software"
echo ""

# Get repository name
REPO_NAME="Ethics-Labs-Learning-Software"

# Check if we're in the right directory
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository. Please run this from the lms directory."
    exit 1
fi

# Check if GitHub CLI is available
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI found!"
    echo ""
    echo "Creating repository on GitHub..."
    
    # Check if user is logged in
    if gh auth status &> /dev/null; then
        # Create repository
        gh repo create "$REPO_NAME" \
            --public \
            --description "Ethics Labs Learning Management System - Customized LMS with AI Ethics courses" \
            --source=. \
            --remote=ethicslabs \
            --push
        
        echo ""
        echo "✅ Repository created and pushed!"
        echo "🌐 View at: https://github.com/$(gh api user --jq .login)/$REPO_NAME"
    else
        echo "⚠️  Not logged into GitHub CLI"
        echo "Run: gh auth login"
        echo ""
        echo "Or create the repo manually and use the commands below:"
        MANUAL_MODE=true
    fi
else
    echo "⚠️  GitHub CLI not installed"
    echo "Install with: brew install gh"
    echo ""
    MANUAL_MODE=true
fi

if [ "$MANUAL_MODE" = true ]; then
    echo "📝 Manual Setup Instructions:"
    echo ""
    echo "1. Create repository on GitHub:"
    echo "   Visit: https://github.com/new"
    echo "   Name: $REPO_NAME"
    echo "   Description: Ethics Labs Learning Management System"
    echo "   Choose Public or Private"
    echo "   Don't initialize with README"
    echo ""
    echo "2. After creating, run these commands:"
    echo ""
    echo "   # Add new remote"
    echo "   git remote add ethicslabs https://github.com/YOUR_USERNAME/$REPO_NAME.git"
    echo ""
    echo "   # Or remove old remote and add new one"
    echo "   git remote remove origin"
    echo "   git remote add origin https://github.com/YOUR_USERNAME/$REPO_NAME.git"
    echo ""
    echo "   # Push to new repository"
    echo "   git push -u origin develop"
    echo "   # Or if you want main branch:"
    echo "   git checkout -b main"
    echo "   git push -u origin main"
    echo ""
fi
