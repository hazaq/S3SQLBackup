# Author Hazaq
# email hazaq.naeem@gmail.com
# Release 25-08-2017


$global:logLocation = "C:\Scripts\backup.log"
$backupDir = "C:\DailyBackups"
$serverName = "db-server-name"
$bucket = "example-bucket"
$s3Prefix = "s3 prefix"
$s3StorageClass = "STANDARD_IA" #Valid choices are: STANDARD | REDUCED_REDUNDANCY | STANDARD_IA

function checkSQLBackupJob($sName)
{
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
    $srv= NEW-OBJECT ('MICROSOFT.SQLSERVER.MANAGEMENT.SMO.SERVER') $sName
    $backup = $srv.jobserver.jobs| where-object {$_.name -like "DailyBackups.Subplan_1"} 	
    $status = $backup.CurrentRunStatus
    return $status
}

function log($comment)
{
    $time = Get-Date
    $logTime = $time.ToString("hh:mm - dd MM yyyy") 
    echo "$logTime  $comment" >> $logLocation
}

$date = Get-Date
$dirName = $date.ToString("ddMMyyyy")

log("Script Started..............")
$backupCurrentStatus = checkSQLBackupJob($serverName)
if ( $backupCurrentStatus -eq "Idle")
{
    aws s3api put-object --bucket $bucket --key $s3Prefix/$dirName/
    log('S3 Sync started.............')
    aws s3 sync $backupDir s3://$bucket/$s3Prefix/$dirName/ --dryrun --quiet --storage-class $s3StorageClass
    log('S3 Sync completed.')
}
else 
{
    log('S3 copy failed ! Check the backup job status')
}
