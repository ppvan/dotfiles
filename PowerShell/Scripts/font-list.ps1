# font-list.ps1
(New-Object System.Drawing.Text.InstalledFontCollection).Families | ForEach-Object { $_.Name }