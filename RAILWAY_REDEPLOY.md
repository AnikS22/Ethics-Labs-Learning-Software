# Trigger Railway Redeploy

## How to Redeploy on Railway

### Option 1: Manual Redeploy (Recommended)

1. Go to **Railway Dashboard**: https://railway.app
2. Click on your **project**
3. Click on your **LMS service** (the main app, not databases)
4. Go to **"Deployments"** tab
5. Click **"..."** (three dots) on the latest deployment
6. Click **"Redeploy"**

OR

1. Go to your **LMS service**
2. Click **"Settings"** tab
3. Scroll down to **"Deploy"** section
4. Click **"Redeploy"** button

### Option 2: Check Auto-Deploy Settings

1. Go to **LMS service** → **"Settings"** tab
2. Check **"Auto Deploy"** section
3. Make sure **"Automatic deploys"** is **enabled**
4. Verify it's watching the correct branch: `main`

### Option 3: Force Push (If Railway isn't detecting changes)

Railway might not detect commits if auto-deploy is off. Check:

1. **Railway Dashboard** → **LMS service** → **"Settings"**
2. Look for **"Source"** section
3. Verify:
   - Repository: `AnikS22/Ethics-Labs-Learning-Software`
   - Branch: `main`
   - Auto Deploy: **Enabled**

### Option 4: Verify Railway is Connected to GitHub

1. **Railway Dashboard** → **LMS service** → **"Settings"**
2. Check **"Source"** section
3. Should show:
   ```
   Repository: AnikS22/Ethics-Labs-Learning-Software
   Branch: main
   ```

If it shows a different repository or branch, update it.

---

## Verify Deployment is Triggered

After redeploying:

1. Go to **"Deployments"** tab
2. You should see a **new deployment** starting
3. Status will show:
   - 🔨 **Building** (yellow)
   - 🚀 **Deploying** (blue)
   - ✅ **Active** (green)

4. Click on the new deployment to see **logs**
5. Look for:
   ```
   ✅ bench found: /home/frappe/.local/bin/bench
   OR
   ✅ bench installed successfully: /home/frappe/.local/bin/bench
   ```

---

## Troubleshooting

### Railway Still Not Redeploying?

**Check:**
1. Is Railway connected to the correct GitHub repo?
2. Is the correct branch (`main`) selected?
3. Is auto-deploy enabled?
4. Are there any build errors preventing deployment?

### Manual Redeploy Not Working?

**Try:**
1. Disconnect and reconnect the GitHub repo
2. Check Railway status: https://status.railway.app
3. Verify your Railway plan has resources available

### Still Seeing Old Errors?

**After redeploy:**
1. Check the **latest deployment logs** (not old ones)
2. Make sure you're looking at the **newest** deployment
3. Wait 2-3 minutes for deployment to start (first build takes time)

---

## What Changed?

Latest commit includes:
- ✅ Fixed `bench command not found` error
- ✅ Bench auto-installation if missing
- ✅ Improved PATH detection
- ✅ Better error logging

**Commit:** `63eb5189` - "Fix 'bench command not found' on Railway"

---

**Once you manually redeploy, the new code will be used! 🚀**
