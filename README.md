
aws-s3
======

Simple shell script to get the contents of the file on Amazon S3.  


## Usage:

- help:  
  ```
  $ aws-s3 help
  ```

- cat:
  ```
  $ aws-s3 cat s3://your-bucket-1/path/to/file s3://your-bucket-2/path/to/file ...
  ```


When executing this script, please use it on EC2 which has IAM Role allowed access to Amazon S3,  
or set the following environment variable:  

```
$ export AWS_REGION=ap-northeast-1
$ export AWS_ACCESS_KEY_ID=AKIA****************
$ export AWS_SECRET_ACCESS_KEY=****************************************
```


## Note:

This program relies heavily on "AWS Signature Version 4".  

#### References:

  - Signing AWS Requests with Signature Version 4 - Amazon Web Services  
    https://docs.aws.amazon.com/general/latest/gr/sigv4_signing.html  

  - Signature Calculations for the Authorization Header:  
      Transferring Payload in a Single Chunk (AWS Signature Version 4) - Amazon Simple Storage Service  
    https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-header-based-auth.html  


