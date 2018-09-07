
lw
===

Simple shell script with very little dependency.  
Like a **L**one **W**olf that does not depend on anyone... _(:3」∠)_  


## Usage:

#### `help`
Display help.  

    $ lw help


#### `s3 list [<bucket>]`
list the contents on Amazon S3.  

    $ lw s3 list [<your-bucket>]
    $ lw s3 ls [<your-bucket>]


#### `s3 get <s3path>`
get the contents of the file on Amazon S3.  

    $ lw s3 get s3://your-bucket/path/to/file
    $ lw s3 cat s3://your-bucket/path/to/file


When executing this script, please use it on EC2 which has IAM Role allowed access to Amazon S3,  
or set the following environment variable:  

    $ export AWS_REGION=ap-northeast-1
    $ export AWS_ACCESS_KEY_ID=AKIA****************
    $ export AWS_SECRET_ACCESS_KEY=****************************************


## Note:
This program relies heavily on "AWS Signature Version 4".  

#### References:
  - Signing AWS Requests with Signature Version 4 - Amazon Web Services  
    https://docs.aws.amazon.com/general/latest/gr/sigv4_signing.html  
  - Signature Calculations for the Authorization Header:  
      Transferring Payload in a Single Chunk (AWS Signature Version 4) - Amazon Simple Storage Service  
    https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html  

