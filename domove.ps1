# PowerShell Script to Move Downloads from User's Profile to SMB Share with Error Handling
# Execute from an elevated prompt: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# Ensure the script is run with elevated permissions (required for network drives)
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as an administrator." -ForegroundColor Red
    exit
}

# Define the source and destination paths, modify this to suit your environment
$sourcePath = [System.Environment]::GetFolderPath("MyDocuments") + "\Downloads"
$destinationPath = "\\server.local\shared\downloads"

# Check if the Downloads folder exists locally
if (Test-Path -Path $sourcePath) {
    try {
        # Start moving files from local Downloads to network share
        Write-Host "Moving content of Downloads to $destinationPath..." -ForegroundColor Green
        Move-Item -Path $sourcePath\* -Destination $destinationPath -Recurse -ErrorAction Stop
        Write-Host "Content has been successfully moved to the SMB share." -ForegroundColor Green
    } catch {
        # Handle any errors that occur during file move operation
        Write-Host "An error occurred while moving files: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Downloads folder not found locally." -ForegroundColor Yellow
    exit 1
}
