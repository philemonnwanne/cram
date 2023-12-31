package test

import (
	"os"
	"testing"

	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestS3Bucket(t *testing.T) {
	terraformEnv := "dev"
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: fmt.Sprintf("../../../terraform/env/%s/storage", terraformEnv),
		TerraformBinary: "terragrunt",
	})

	TerraformHiddenDir := fmt.Sprintf("../../../terraform/env/%s/storage/.terragrunt-cache", terraformEnv)

	// at the end of the test clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// do `terraform init` only on first run
	folderInfo, err := os.Stat(TerraformHiddenDir)
	if os.IsNotExist(err) {
		fmt.Println("Folder does not exist:", folderInfo)
		// run `terraform init & apply` and fail if there are any errors
		terraform.InitAndApply(t, terraformOptions)
	}

	fmt.Println("FOLDER WAS FOUND @:", TerraformHiddenDir)
	// run `terraform apply` and fail if there are any errors
	terraform.Apply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	bucket_name := terraform.Output(t, terraformOptions, "backend_s3_bucket_name")

	// anonymous function to return bucket name
	var s3_bucket = func() (bucketName string) {
		// initialize the session that the SDK uses to load credentials from the shared credentials file
		sess, err := session.NewSession(&aws.Config{
			Region: aws.String("us-east-1"),
		})

		if err != nil {
			fmt.Println("Error creating session ", err)
			return err.Error()
		}

		// create a new Amazon S3 service client:
		svc := s3.New(sess)

		input := &s3.ListBucketsInput{}

		result, err := svc.ListBuckets(input)

		for _, bucket := range result.Buckets {

			bucketName := aws.StringValue(bucket.Name)

			if bucketName == bucket_name {
				return bucketName
			}
		}
		return
	}
	// Verify that our Bucket exists
	actualStatus := s3_bucket()
	expectedStatus := bucket_name

	assert.Equal(t, expectedStatus, actualStatus, "bucket not found")
}