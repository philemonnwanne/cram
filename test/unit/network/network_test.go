package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	// "github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestVpc(t *testing.T) {
	// t.Parallel()

	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	awsRegion := "us-east-1"
	terraformEnv := "dev"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: fmt.Sprintf("../../../terraform/env/%s/network/vpc", terraformEnv),
		TerraformBinary: "terragrunt",
	})

	// at the end of the test clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)
	// run `terraform init & apply` and fail if there are any errors
	terraform.InitAndApply(t, terraformOptions)
	// Run `terraform output` to get the value of an output variable
	// publicSubnetId := terraform.Output(t, terraformOptions, "vpc_public_subnet_id")

	vpcId := terraform.Output(t, terraformOptions, "vpc_id")

	subnets := aws.GetSubnetsForVpc(t, vpcId, awsRegion)

	require.Equal(t, 4, len(subnets))
	// Verify if the network that is supposed to be public is really public
	// assert.True(t, aws.IsPublicSubnet(t, publicSubnetId, awsRegion))
}