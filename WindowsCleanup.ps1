# Run as Administrator for full effect

# Function to delete files safely
function Remove-Files($path) {
    if (Test-Path $path) {
        Write-Output "Cleaning: $path"
        Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    } else {
        Write-Output "Path not found: $path"
    }
}

# 1. User Temp
Remove-Files "$env:TEMP"

# 2. System Temp
Remove-Files "C:\Windows\Temp"

# 3. Prefetch
Remove-Files "C:\Windows\Prefetch"

# 4. SoftwareDistribution Download
Remove-Files "C:\Windows\SoftwareDistribution\Download"

# 5. Windows Update Logs
Remove-Files "C:\Windows\Logs"

# 6. Windows.old (if exists)
Remove-Files "C:\Windows.old"

# 7. Empty Recycle Bin
Write-Output "Emptying Recycle Bin..."
$(New-Object -ComObject Shell.Application).NameSpace(0xA).Items() | ForEach-Object { Remove-Item $_.Path -Force -Recurse -ErrorAction SilentlyContinue }

# 8. Clear Thumbnail Cache
Remove-Files "$env:LOCALAPPDATA\Microsoft\Windows\Explorer"

# 9. Clear Windows Store Cache
Write-Output "Clearing Microsoft Store Cache..."
Start-Process "wsreset.exe" -Wait

Write-Output "Cleanup completed!"
