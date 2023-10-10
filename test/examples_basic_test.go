package test

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/cloudwatchlogs"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"log"
	"strings"
	"testing"
	"time"
)

func TestExamplesBasicTest(t *testing.T) {
	uniqueId := strings.ToLower(random.UniqueId())

	rootFolder := ".."
	terraformFolderRelativeToRoot := "examples/basic"
	tempTestFolder := test_structure.CopyTerraformFolderToTemp(t, rootFolder, terraformFolderRelativeToRoot)

	terraformOptions := &terraform.Options{
		TerraformDir: tempTestFolder,
		Vars: map[string]interface{}{
			"aws_region":                   "us-east-1",
			"domain_name":                  uniqueId + "domain.com",
			"certificate_expiration_email": uniqueId + "@test.com",
			"s3_bucket_name":               uniqueId + "-s3-bucket",
			"namespace_id":                 uniqueId + "-7824-4e08-97fd-9b5d1792a027",
			"namespace_secret":             uniqueId + "UdfdTK7P0FD5",
			"mendix_operator_version":      "2.13.0",
		},
		BackendConfig: map[string]interface{}{
			"backend": "local",
		},
	}

	// Destroy order
	modules := []string{
		"module.mendix_private_cloud_example.module.eks_blueprints_kubernetes_addons.module.ingress_nginx.helm_release.this[0]",
		"module.mendix_private_cloud_example.module.eks_blueprints_kubernetes_addons.module.kube_prometheus_stack.helm_release.this[0]",
		"module.mendix_private_cloud_example.module.eks_blueprints_kubernetes_addons.module.aws_load_balancer_controller.helm_release.this[0]",
		"module.mendix_private_cloud_example.module.eks_blueprints_kubernetes_addons",
		"destroy",
	}

	defer test_structure.RunTestStage(t, "destroy", func() {
		for _, target := range modules {
			clusterName := terraform.Output(t, terraformOptions, "cluster_name")
			if target != "destroy" {
				fmt.Println("Destroying " + target + "...")
				terraformOptions := &terraform.Options{
					TerraformDir: tempTestFolder,
					Vars: map[string]interface{}{
						"aws_region":                   "us-east-1",
						"domain_name":                  uniqueId + "domain.com",
						"certificate_expiration_email": uniqueId + "@test.com",
						"s3_bucket_name":               uniqueId + "-s3-bucket",
						"namespace_id":                 uniqueId + "-7824-4e08-97fd-9b5d1792a027",
						"namespace_secret":             uniqueId + "UdfdTK7P0FD5",
						"mendix_operator_version":      "2.13.0",
					},
					BackendConfig: map[string]interface{}{
						"backend": "local",
					},
					Targets: []string{target},
					NoColor: true,
				}

				terraform.Destroy(t, terraformOptions)
			} else {
				// Clean remaining EKS CloudWatch log group.
				fmt.Println("Cleaning " + clusterName + " CloudWatch Log group")
				sess, _ := session.NewSession(&aws.Config{
					Region: aws.String("us-east-1"),
				})
				client := cloudwatchlogs.New(sess)
				get := &cloudwatchlogs.DeleteLogGroupInput{
					LogGroupName: aws.String("/aws/eks/" + clusterName + "/cluster"),
				}
				_, err := client.DeleteLogGroup(get)
				if err != nil {
					fmt.Println(err)
				}
				terraform.Destroy(t, terraformOptions)
			}
		}
	})

	terraform.InitAndApply(t, terraformOptions)
	log.Println("Waiting for 20s before starting to delete everything")
	time.Sleep(time.Second * 20)
}
