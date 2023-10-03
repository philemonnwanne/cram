package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/stretchr/testify/assert"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/ec2"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func configFirewall(t *testing.T, vpcOpts *terraform.Options) *terraform.Options {
	vpcId := terraform.Output(t, vpcOpts, "vpc_id")
	terraformEnv := "dev"

	return &terraform.Options{
		TerraformDir:    fmt.Sprintf("../../../../terraform/env/%s/network/firewall", terraformEnv),
		TerraformBinary: "terragrunt",
		Vars: map[string]interface{}{
			"vpc_id": vpcId,
		},
	}
}

// ============================================

func configVpc(t *testing.T) *terraform.Options {
	terraformEnv := "dev"
	return &terraform.Options{
		TerraformDir:    fmt.Sprintf("../../../../terraform/env/%s/network/vpc", terraformEnv),
		TerraformBinary: "terragrunt",
	}
}

// ============================================

func TestFirewall(t *testing.T) {
	vpcOpts := configVpc(t)
	defer terraform.Destroy(t, vpcOpts) // will be destroyed last
	terraform.InitAndApply(t, vpcOpts)

	firewallOpts := configFirewall(t, vpcOpts)
	defer terraform.Destroy(t, firewallOpts) // will be destroyed first
	terraform.InitAndApply(t, firewallOpts)

	secGrpId := terraform.Output(t, firewallOpts, "backend_security_group_id")

	actualStatus := SecurityGroup(secGrpId)
	expectedStatus := secGrpId

	assert.Equal(t, expectedStatus, actualStatus, "security group not found")
}

func SecurityGroup(secGrpId string) string {

	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("us-east-1"),
	})

	if err != nil {
		fmt.Println("Error creating session ", err)
		// return err.Error()
	}

	svc := ec2.New(sess)

	secGrp_Id := strings.Fields(secGrpId)

	input := &ec2.DescribeSecurityGroupsInput{
		GroupIds: aws.StringSlice(secGrp_Id),
	}

	result, err := svc.DescribeSecurityGroups(input)

	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			default:
				fmt.Println(aerr.Error())
			}
		} else {
			fmt.Println(err.Error())
		}
	}
	return *result.SecurityGroups[0].GroupId
}
