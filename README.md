
lw
===

Simple shell script with very little dependency.  
Like a **L**one **W**olf that does not depend on anyone... _(:3」∠)_  


## TL;DR

    curl -sS https://raw.githubusercontent.com/djeeno/lw/master/lw | sh /dev/stdin s3 ls


## Usage:

When executing this script,
  - Please use it on EC2 which has IAM Role allowed access to Amazon S3,
  - or save `~/.aws/config` and `~/.aws/credentials`,
  - or set the following environment variables:

    ```
    $ export AWS_REGION=ap-northeast-1
    $ export AWS_ACCESS_KEY_ID=AKIA****************
    $ export AWS_SECRET_ACCESS_KEY=****************************************
    ```


#### `help`
Display help.  

    $ lw help


#### `s3 list`
List the contents on Amazon S3.  

    $ lw s3 list [<your-bucket>[<prefix>]]
    $ lw s3 ls [<your-bucket>[<prefix>]]


#### `s3 get`
Get the contents of the file on Amazon S3.  

    $ lw s3 get s3://your-bucket/path/to/file
    $ lw s3 cat s3://your-bucket/path/to/file


## Note:
This program relies heavily on "AWS Signature Version 4".  

#### References:
  - Signing AWS Requests with Signature Version 4 - Amazon Web Services  
    https://docs.aws.amazon.com/general/latest/gr/sigv4_signing.html  
  - Authenticating Requests: Using Query Parameters (AWS Signature Version 4)
    https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/API/sigv4-query-string-auth.html
  - Signature Calculations for the Authorization Header:  
    Transferring Payload in a Single Chunk (AWS Signature Version 4) - Amazon Simple Storage Service  
    https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html  
  - GET Bucket (List Objects) Version 2  
    https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/API/v2-RESTBucketGET.html  

