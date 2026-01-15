# Railway Database Configuration Guide

## Databases Required for Ethics Labs LMS

Your LMS needs **TWO databases** on Railway:

1. **MySQL/MariaDB** - Primary database (stores all app data)
2. **Redis** - For caching and background jobs

**⚠️ Important:** PostgreSQL is **NOT supported** - Frappe/LMS requires MySQL/MariaDB only.

---

## What You Need to Do on Railway

### Step 1: Add MySQL Service

1. Go to your Railway project
2. Click **"+ New"**
3. Select **"Database"** → **"Add MySQL"**
   - Railway calls it "MySQL" but it's MariaDB-compatible (they're the same)
   - This is perfect for your LMS!

4. Railway will automatically create these environment variables:
   - `MYSQLHOST` - Database host
   - `MYSQLPORT` - Database port (usually 3306)
   - `MYSQLDATABASE` - Database name
   - `MYSQLUSER` - Database user
   - `MYSQLPASSWORD` - Database password
   - `MYSQL_URL` - Full connection URL

**Note the service name** (it might be `MySQL`, `MySQL-1`, `mysql`, etc.) - you'll need this for linking!

---

### Step 2: Add Redis Service

1. In the same Railway project, click **"+ New"** again
2. Select **"Database"** → **"Add Redis"**

3. Railway will create:
   - `REDISHOST` - Redis host
   - `REDISPORT` - Redis port (usually 6379)
   - `REDIS_URL` - Full connection URL

**Note the service name** (might be `Redis`, `Redis-1`, `redis`, etc.)

---

### Step 3: Link Database Variables to LMS Service

1. Click on your **LMS service** (the main app, not the databases)
2. Go to **"Variables"** tab
3. Add these environment variables:

```bash
# MySQL Configuration - Links to your MySQL service
MYSQL_HOST=${{MySQL.MYSQLHOST}}
MYSQL_ROOT_PASSWORD=${{MySQL.MYSQLPASSWORD}}

# Redis Configuration - Links to your Redis service
REDIS_HOST=${{Redis.REDISHOST}}
REDIS_PORT=${{Redis.REDISPORT}}
```

**⚠️ CRITICAL:** Replace `MySQL` and `Redis` with your **actual service names**!

For example:
- If Railway named it `MySQL-1`, use: `${{MySQL-1.MYSQLHOST}}`
- If Railway named it `mysql`, use: `${{mysql.MYSQLHOST}}`
- Check your Railway dashboard for the exact service names

---

## How It Works

### Your Code Already Handles This! ✅

Your `docker/init.sh` script already reads these environment variables:

```bash
# Line 33-36 in docker/init.sh
MARIADB_HOST="${MYSQL_HOST:-mariadb}"           # Uses Railway's MYSQL_HOST
REDIS_HOST="${REDIS_HOST:-redis}"                # Uses Railway's REDIS_HOST
REDIS_PORT="${REDIS_PORT:-6379}"                 # Uses Railway's REDIS_PORT
MARIADB_PASSWORD="${MYSQL_ROOT_PASSWORD:-123}"   # Uses Railway's MYSQL_ROOT_PASSWORD
```

The `:-default` syntax means:
- **If the variable exists**, use it (Railway's database)
- **If not**, use the default (for local Docker testing)

So your code will **automatically work** once you:
1. ✅ Add MySQL and Redis services on Railway
2. ✅ Link the environment variables correctly

**No code changes needed!** 🎉

---

## PostgreSQL: Not Supported

**Q: Can I use PostgreSQL instead of MySQL?**

**A: No.** Frappe Framework (which powers your LMS) requires MySQL/MariaDB. PostgreSQL is not supported.

**Why?**
- Frappe is built specifically for MySQL/MariaDB
- Uses MySQL-specific SQL syntax
- Database schema is MySQL-optimized
- Cannot be changed without rewriting Frappe

**Good news:** Railway's "MySQL" is actually MariaDB-compatible, which is perfect for your LMS!

---

## Verification Checklist

After setting up databases on Railway, verify:

- [ ] MySQL service is running (green status in Railway)
- [ ] Redis service is running (green status in Railway)
- [ ] Environment variables are linked correctly:
  - [ ] `MYSQL_HOST` points to MySQL service
  - [ ] `MYSQL_ROOT_PASSWORD` points to MySQL service
  - [ ] `REDIS_HOST` points to Redis service
  - [ ] `REDIS_PORT` points to Redis service
- [ ] Service names in variables match Railway's actual service names

---

## Example Configuration

Here's what your Railway environment variables should look like:

```
# MySQL Connection (from MySQL service)
MYSQL_HOST=${{MySQL.MYSQLHOST}}
→ Resolves to: railway.app (or similar)

MYSQL_ROOT_PASSWORD=${{MySQL.MYSQLPASSWORD}}
→ Resolves to: ••••••••••••••• (Railway's generated password)

# Redis Connection (from Redis service)
REDIS_HOST=${{Redis.REDISHOST}}
→ Resolves to: redis.railway.internal (or similar)

REDIS_PORT=${{Redis.REDISPORT}}
→ Resolves to: 6379
```

---

## Troubleshooting

### "Can't connect to MySQL server"

**Problem:** LMS can't connect to MySQL

**Fix:**
1. Check MySQL service is running in Railway
2. Verify `MYSQL_HOST` variable is correctly linked
3. Check service name matches exactly (case-sensitive!)

### "Can't connect to Redis"

**Problem:** LMS can't connect to Redis

**Fix:**
1. Check Redis service is running in Railway
2. Verify `REDIS_HOST` and `REDIS_PORT` are correctly linked
3. Check service name matches exactly

### Service Names Don't Match

**Problem:** Environment variables say "MySQL" but Railway named it "MySQL-1"

**Fix:**
- Update variables to use the exact service name:
  ```
  # Wrong:
  MYSQL_HOST=${{MySQL.MYSQLHOST}}
  
  # Correct (if service is named MySQL-1):
  MYSQL_HOST=${{MySQL-1.MYSQLHOST}}
  ```

### Database Connection Works But App Still Fails

**Check:**
1. MySQL service has enough resources (Railway free tier might be limited)
2. Redis service is running
3. All environment variables are set before deployment starts

---

## Database Configuration Summary

| Database | Purpose | Railway Service | Required? |
|----------|---------|----------------|-----------|
| **MySQL/MariaDB** | Primary database (stores all data) | MySQL | ✅ **YES** |
| **Redis** | Caching & background jobs | Redis | ✅ **YES** |
| **PostgreSQL** | N/A - Not supported | N/A | ❌ **NO** |

---

## What You Need to Do

### ✅ Required Actions:

1. **On Railway:**
   - [ ] Add MySQL service
   - [ ] Add Redis service
   - [ ] Link environment variables to LMS service
   - [ ] Verify service names match in variables

### ✅ Already Done (No Changes Needed):

- [x] Code already handles Railway environment variables
- [x] `docker/init.sh` reads `MYSQL_HOST`, `REDIS_HOST`, etc.
- [x] Fallback values for local Docker testing work correctly

---

## Quick Reference

**MySQL Service Variables (Railway creates these):**
- `MYSQLHOST`
- `MYSQLPORT`
- `MYSQLDATABASE`
- `MYSQLUSER`
- `MYSQLPASSWORD`

**Redis Service Variables (Railway creates these):**
- `REDISHOST`
- `REDISPORT`

**LMS Service Variables (You link these):**
- `MYSQL_HOST=${{YourMySQLService.MYSQLHOST}}`
- `MYSQL_ROOT_PASSWORD=${{YourMySQLService.MYSQLPASSWORD}}`
- `REDIS_HOST=${{YourRedisService.REDISHOST}}`
- `REDIS_PORT=${{YourRedisService.REDISPORT}}`

---

## Support

If you have issues:
1. Check Railway logs for database connection errors
2. Verify all services are running (green status)
3. Check environment variables are linked correctly
4. See `RAILWAY_TROUBLESHOOTING.md` for more help

---

**Summary:** You need MySQL and Redis on Railway. Your code already handles it - just link the environment variables! 🚀
