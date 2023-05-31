#  The following script listens for new files in a folder and processes them
#
# BEGIN SCRIPT

$folder = 'C:\Users\Public\source'             # My path
$filter = '*.*'                 # File types to be monitored

$fsw = New-Object IO.FileSystemWatcher $folder, $filter -Property @{    # Listening function
 IncludeSubdirectories = $false              # Put "True" to scan subfolders
 EnableRaisingEvents = $true
 NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
}
$onCreated = Register-ObjectEvent $fsw Created -SourceIdentifier FileCreated -Action {
 $path = $Event.SourceEventArgs.FullPath            
 $name = $Event.SourceEventArgs.Name                
 $changeType = $Event.SourceEventArgs.ChangeType    
 $timeStamp = $Event.TimeGenerated                  
 $destination = 'C:\Users\Public\dest\'                    
 $outfile = $destination + $name
 Write-Host "The file '$name' was $changeType and processed at $timeStamp"   -ForegroundColor Yellow # Log message on the screen
 (Get-Content $path -Raw) -replace "`n",'' | Set-Content -path $outfile  
 Remove-Item $path   # Delete original files
}

#  END SCRIPT
