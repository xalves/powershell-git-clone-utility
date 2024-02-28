param(
    [string]$gitUrl,
    [string]$clonePath = "C:\Path\To\Clone\Directory",
    [int]$retryCount = 3
)

function Clone-GitRepository {
    param(
        [string]$Url,
        [string]$Path,
        [int]$Retries
    )
    
    $currentRetry = 0
    do {
        Write-Host "Attempting to clone $Url into $Path. Attempt number: $($currentRetry + 1)"
        $output = git clone $Url $Path 2>&1
        $lastExitCode = $LASTEXITCODE

        if ($lastExitCode -eq 0) {

            Write-Host "Repository cloned successfully."
            return
        } else {

            Write-Host "An error occurred: $output"
            
            if ($currentRetry -eq $Retries) {
                Write-Host "Maximum retry attempts reached. Clone failed."
                return
            } else {
                Write-Host "Retrying in 5 seconds..."
                Start-Sleep -Seconds 5
            }
        }

        $currentRetry++
    } while ($currentRetry -le $Retries)
}

# Invoke the clone function with the provided parameters
Clone-GitRepository -Url $gitUrl -Path $clonePath -Retries $retryCount