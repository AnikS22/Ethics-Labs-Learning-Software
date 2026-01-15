# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is **Ethics Labs**, a Learning Management System (LMS) built on Frappe Framework. It's a customized fork of Frappe LMS with complete Ethics Labs branding and theming.

**Tagline**: "Where GenZ shapes the future of ethical AI"

The project consists of two main parts:
- **Backend**: Python-based Frappe application (`lms/` directory)
- **Frontend**: Vue 3 SPA using Frappe UI (`frontend/` directory)

## Development Commands

### Docker Development (Recommended)

```bash
# Start the LMS
./LAUNCH.sh
# Or manually:
cd docker && docker compose up -d

# Stop containers
cd docker && docker compose down

# View logs
cd docker && docker compose logs -f

# Access at http://localhost:8000
```

### Local Development (Bench)

```bash
# Start development server
bench start

# Build frontend assets
cd apps/lms/frontend && yarn build

# Run frontend dev server
yarn dev
# Or: npm run dev

# Install dependencies
cd frontend && yarn install

# Run Python tests
bench --site [site-name] run-tests --app lms

# Run UI tests (Cypress)
npm run test-local
```

### Frontend Development

```bash
# Frontend directory: lms/frontend/
cd frontend

# Install dependencies
yarn install

# Development mode (hot reload)
yarn dev

# Build for production
yarn build
# This builds to ../lms/public/frontend/ and copies to ../lms/www/lms.html
```

### Linting and Code Quality

```bash
# Pre-commit hooks (ruff, prettier, eslint)
pre-commit run --all-files

# Python linting with ruff
ruff check lms/
ruff format lms/

# JavaScript/Vue formatting
prettier --write "frontend/**/*.{js,vue}"
```

## Architecture

### Backend Structure

The backend follows Frappe's DocType-based architecture:

- **`lms/lms/doctype/`** - Core data models (LMS Course, LMS Certificate, LMS Batch, etc.)
  - Each doctype has: `.json` schema, `.py` controller, `test_*.py` tests
  - Key doctypes: `lms_course`, `lms_certificate`, `lms_batch`, `lms_enrollment`, `lms_quiz`

- **`lms/lms/api.py`** - API endpoints exposed to frontend (whitelisted methods)

- **`lms/hooks.py`** - Frappe app configuration
  - Website routes, redirects, and route rules
  - Document event hooks
  - Scheduled tasks (hourly, daily)
  - Jinja methods and markdown macro renderers

- **`lms/www/`** - Web pages and server-side rendering
  - `lms.py` - Main SPA entry point (renders Vue app)
  - `certificate.py` - Certificate rendering logic

- **`lms/lms/doctype/*/` hierarchy** - Business logic lives in controller files

### Frontend Structure

Vue 3 SPA with Vue Router and Pinia:

- **`frontend/src/router.js`** - Route definitions
- **`frontend/src/stores/`** - Pinia stores for state management
- **`frontend/src/components/`** - Reusable Vue components
- **`frontend/src/views/`** or `pages/` - Page-level components
- **`frontend/vite.config.js`** - Build configuration with Frappe UI plugin

The frontend is built using Vite and outputs to:
- Assets: `lms/public/frontend/`
- HTML entry: `lms/www/lms.html`

### Course Content Architecture

3-level hierarchy:
1. **Course** (`LMS Course`) - Top-level container
2. **Chapter** (`Course Chapter`) - Groups lessons within a course
3. **Lesson** (`Course Lesson`) - Individual learning content

Additional content types:
- **Quiz** (`LMS Quiz`) - Assessments with multiple question types
- **Assignment** (`LMS Assignment`) - Submission-based assessments
- **Live Class** (`LMS Live Class`) - Zoom integration for live sessions
- **Batch** (`LMS Batch`) - Group learners by cohort

### Certificate System

Certificates are generated via print formats:
- Template: `lms/lms/print_format/certificate/`
- Generated when: Course completion or manual issuance
- Accessible at: `/courses/[course-name]/[certificate-id]`
- Customization: See `CERTIFICATE_DESIGN_GUIDE.md`

## Key Technical Details

### Frappe Framework Integration

- **API Whitelisting**: Methods decorated with `@frappe.whitelist()` are accessible from frontend
- **DocType Controllers**: Business logic in `.py` files next to `.json` schemas
- **Hooks System**: Document events, scheduled tasks, website routes all configured in `hooks.py`
- **Permission System**: `has_website_permission` functions control access

### Frontend-Backend Communication

Frontend uses `frappe-ui` library which provides:
- `createResource()` - For API calls to whitelisted methods
- `createDocumentResource()` - For CRUD on DocTypes
- Auto-generated types from backend schemas

### Scheduled Tasks

Defined in `hooks.py` under `scheduler_events`:
- **Hourly**: Certificate evaluations, course statistics, live class attendance
- **Daily**: Payment reminders, batch reminders, course notifications

### Markdown Macros

Lessons support custom macros for embedding content:
- `{{ YouTubeVideo }}`, `{{ Video }}`, `{{ Audio }}`
- `{{ Quiz }}`, `{{ Assignment }}`, `{{ Exercise }}`
- `{{ Embed }}`, `{{ PDF }}`

Renderers defined in `lms/plugins.py` and registered in `hooks.py`

## Testing

### Python Tests

```bash
# Run all tests for the app
bench --site [site-name] run-tests --app lms

# Run specific test
bench --site [site-name] run-tests --app lms --module lms.lms.doctype.lms_course.test_lms_course

# Run with coverage
bench --site [site-name] run-tests --app lms --coverage
```

### UI Tests (Cypress)

```bash
# Open Cypress UI (interactive)
npm run test-local

# Run headless
npm run test
```

Test files in `cypress/e2e/`

## Ethics Labs Customization

This is a customized version with complete Ethics Labs branding:

- **Brand Name**: "Ethics Labs" (no references to Frappe in user-facing text)
- **Tagline**: "Where GenZ shapes the future of ethical AI"
- **Color Scheme**:
  - Primary: #0099ff (cyan blue from ethicslabs.ai)
  - Secondary: #FF8C00 (orange), #FFD700 (gold)
  - Accent: #FF4444 (red)
  - Background: #FFFFFF (white)
  - Text: #000000 (black), #666666 (gray)
- **Typography**:
  - Display/Headings: Jacquard 24 (serif, decorative)
  - Body Text: IBM Plex Sans (sans-serif, weights 400-700)
  - Monospace: IBM Plex Mono
- **Certificate Template**: Custom design with decorative SVG elements (brain, neural network, hands)
- **Site Title**: Configured in `lms/www/lms.py`

### Key Branding Files

- `package.json` - App description
- `setup.py` - Package description
- `lms/www/lms.py` - Site title/meta tags
- `lms/lms/print_format/certificate/` - Certificate template

See `ETHICS_LABS_BRANDING.md` for full customization details.

## Common Development Tasks

### Creating a New DocType

1. Use Frappe desk: Go to DocType List → New
2. Or use CLI: `bench new-doctype [doctype-name]`
3. Controller logic goes in `lms/lms/doctype/[doctype_name]/[doctype_name].py`
4. Write tests in `test_[doctype_name].py`

### Adding a New API Endpoint

In any `.py` file (commonly `lms/lms/api.py`):

```python
import frappe

@frappe.whitelist()
def my_custom_endpoint(param1, param2):
    # Your logic here
    return {"result": "data"}
```

Call from frontend using frappe-ui `createResource()`.

### Adding a Frontend Route

1. Define route in `frontend/src/router.js`
2. Create corresponding component in `frontend/src/components/` or `views/`
3. Build frontend: `cd frontend && yarn build`

### Modifying Certificate Design

1. Go to: Print Format → Certificate (`/app/print-format/certificate`)
2. Edit HTML/CSS directly in the format editor
3. Or modify: `lms/lms/print_format/certificate/certificate.json`
4. See `CERTIFICATE_DESIGN_GUIDE.md`

## Database Schema

Frappe uses MariaDB/MySQL with automatic schema management:
- Schema defined in `.json` files for each DocType
- Migrations handled automatically by Frappe
- Run `bench migrate` to apply schema changes

## Important Conventions

- **Python**: Follow PEP 8, use `ruff` for linting/formatting
- **JavaScript/Vue**: Use `prettier` and `eslint`
- **File naming**: snake_case for Python, PascalCase for Vue components
- **API methods**: Must be whitelisted with `@frappe.whitelist()` decorator
- **Permissions**: Use `has_permission` and `has_website_permission` functions

## Deployment

See `DEPLOYMENT_GUIDE.md` for production deployment instructions.

Quick deployment:
```bash
python3 easy-install.py deploy \
    --project=learning_prod_setup \
    --email=your@email.com \
    --image=ghcr.io/frappe/lms \
    --version=stable \
    --app=lms \
    --sitename your-domain.com
```

## Additional Resources

- **Quick Start**: See `START_HERE.md` and `QUICK_START.md`
- **Testing**: See `TESTING_GUIDE.md`
- **Course Setup**: See `COURSE_SETUP_GUIDE.md`
- **Theme Customization**: See `ETHICS_LAB_THEME_GUIDE.md`
- **Frappe Docs**: https://frappeframework.com/docs
- **Frappe UI Docs**: https://github.com/frappe/frappe-ui
