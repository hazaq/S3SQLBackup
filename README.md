# S3SQLBackup
It is a simple script to copy SQL backups to S3, the script is intelligent enough to see whether the backup is running or not. 
If the SQL agent backup is running the script will not run and log the error in log location. If the SQL agent backup is not running then the script will create a prefix in the S3 bucket with the following formate ddMMyyyy and copy the backup in to the directory. 

## Pre-requisites
On the SQL machine the AWSCLI needs to be installed and configured with a User/Role that have enough permission on the S3 bucket 
to ‘PutObject’ , ‘GetObject’ and ‘DeleteObject’. On the aws side create the bucket and don’t forget to place a lifecycle policy 
on the bucket as you want.

## Configuration
Following parameters needs to configured on the script

 $global:logLocation = "C:\Scripts\backup.log" #Location of the log file 
 $backupDir = "C:\DailyBackups" #Location of local Backup

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
            "Resource": "arn:aws:s3:::*"
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
