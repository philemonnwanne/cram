# Test Procedure

<!-- In the S3Bucket() function, replace the variable `bucketName` with your desired s3 bucket. -->

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
