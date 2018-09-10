
laws
===

Lightweight shell script for Amazon Web Service like AWS CLI.


## TL;DR

    curl -sS https://raw.githubusercontent.com/djeeno/laws/master/laws | sh /dev/stdin s3 ls
    curl -sS https://raw.githubusercontent.com/djeeno/laws/master/laws | sh /dev/stdin s3 get s3://your-bucket/path/to/file


## Install

    sudo curl -sS https://raw.githubusercontent.com/djeeno/laws/master/laws -o /usr/local/bin/laws && sudo chmod +x $_


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

    $ laws help


#### `s3 list`
List the contents on Amazon S3.  

    $ laws s3 list [<your-bucket>[<prefix>]]
    $ laws s3 ls [<your-bucket>[<prefix>]]


#### `s3 get`
Get the contents of the file on Amazon S3.  

    $ laws s3 get s3://your-bucket/path/to/file
    $ laws s3 cat s3://your-bucket/path/to/file


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

