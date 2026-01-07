# LeoPack Installation Guide

## 🚀 How to Install (For Users)

Run this command in **CMD** or **PowerShell**:

```powershell
powershell -c "iwr https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.ps1 | iex"
```

_(Replace `YOUR_USERNAME` and `YOUR_REPO` with the actual GitHub path)_

---

## 📦 How to Host (For Admins)

1. **Upload Package**:

   - Go to GitHub -> Releases -> Draft a new release.
   - Attach `LeoPacks.zip`.
   - Publish Release.

2. **Get Link**:

   - Right-click the uploaded `LeoPacks.zip` -> Copy Link Address.

3. **Update Script**:
   - Open `install.ps1`.
   - Paste the link into `$ZipUrl = "..."`.
   - Save and Push `install.ps1` to GitHub.
