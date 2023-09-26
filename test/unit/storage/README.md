# Test Procedure

In the S3Bucket() function, replace the variable `bucketName` with your desired s3 bucket, if you want to test a pre-existing distribution. You can also use the default pointer variable in the test code, which automatically picks up the cloudfront distribution ID from terraforms outputs.

To make use of your own custom ID modify the following lines as such.

➖ Before

```go
distributionId := &cloudfront_id

input := &cloudfront.GetDistributionInput{
    Id: distributionId,
}
```

✅ After

```go
bucketName := "bucket-name-here"

input := &cloudfront.GetDistributionInput{
    Id: &distributionId,
}
```

Get all dependencies in the go file

```go
go mod tidy
```

Run Test

```go
go test
```

# Worthy Mentions

When calling the `GetBucketLocation` API operation, S3 returns nil value for buckets in the North Virginia region (us-east-1).

When calling the `HeadBucket` API operation, S3 returns nil value for buckets in the North Virginia region (us-east-1) and `BadRequest: Bad Request (status code: 400)` for buckets in other regions, while for non-existent buckets, it returns `NotFound: Not Found (status code: 404)`.