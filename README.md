# S3SQLBackup
It is a simple script to copy MS SQL backups to S3, the script is intelligent enough to see whether the SQL Server Agent backup is running or not. If the SQL agent backup is running the script will not run and log the error in log location. If the SQL agent backup is not running then the script will create a prefix in the S3 bucket with the following format ddMMyyyy and copy the backup in to the S3 directory, so you will have a new copy of the backup everyday. The script will not delete old backups that you need to do with S3 lifecycle policy.  

## Pre-requisites
On the SQL machine the AWSCLI needs to be installed and configured with a User/Role that have enough permission on the S3 bucket 
to ‘PutObject’ , ‘GetObject’ and ‘DeleteObject'. Also you need to schedule the script to run with Windows Task Scheduler. On the aws side create the bucket and don’t forget to place a lifecycle policy on the bucket as you want.

## Configuration
Following parameters needs to configured on the script

$global:logLocation = "C:\Scripts\backup.log" #Location of the log file.  
$backupDir = "C:\DailyBackups" #Location of local Backup  
$serverName = "db-server-name” #Server Name, if you are running it on locally localhost should work   
$bucket = "example-bucket"  
$s3Prefix = "s3 prefix"   
$backupJob = "DailyBackups.Subplan_1" #Backup Job name that is defined in SQL Agent  
$s3StorageClass = "STANDARD_IA" #Valid choices are: STANDARD | REDUCED_REDUNDANCY | STANDARD_IA
 
 
## Example IAM Policy for the User/Role

{  
    "Version": "2012-10-17",  
    "Statement": [  
        {  
            "Effect": "Allow",  
            "Action": [  
                "s3:ListAllMyBuckets",  
                "s3:GetBucketLocation"  
            ],  
            "Resource": "arn:aws:s3:::\*"  
        },  
        {  
            "Effect": "Allow",  
            "Action": [  
                "s3:ListBucket"  
            ],  
            "Resource": "arn:aws:s3:::BucketName"  
        },  
        {  
            "Effect": "Allow",  
            "Action": [  
                "s3:PutObject",  
                "s3:GetObject",  
                "s3:DeleteObject"  
            ],  
            "Resource": "arn:aws:s3:::BucketName/*"  
        }  
    ]  
}  
