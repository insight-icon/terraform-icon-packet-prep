package test

import (
	"fmt"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/ssh"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"io/ioutil"
	"path"
	"strconv"
	"strings"
	"testing"
	"time"
)

func TestInstanceStore(t *testing.T) {
	t.Parallel()

	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "examples/min-specs")

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)
		terraform.Destroy(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "setup", func() {
		keyPair := ssh.GenerateRSAKeyPair(t, 4096)
		terraformOptions := configureTerraformOptions(t, exampleFolder, keyPair)

		test_structure.SaveTerraformOptions(t, exampleFolder, terraformOptions)
		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "validate", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)

		//testExportersGoodHealth(t, terraformOptions, keyPair)
		testApiEndpoint(t, terraformOptions)
	})
}

func configureTerraformOptions(t *testing.T, exampleFolder string, keyPair *ssh.KeyPair) *terraform.Options {
	uniqueID := random.UniqueId()

	privKeyPath := path.Join(exampleFolder, uniqueID)

	err := ioutil.WriteFile(privKeyPath, []byte(keyPair.PrivateKey), 0600)
	if err != nil {
		t.Fatal(err)
	}

	//publicKeyBytes := generateLocalPrivKey(privKeyPath)

	terraformOptions := &terraform.Options{
		TerraformDir: exampleFolder,
		OutputMaxLineSize: 1024 * 1024,

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"public_key":    []byte(keyPair.PublicKey),
			"private_key_path":   privKeyPath,
		},
	}

	return terraformOptions
}



//func testExportersGoodHealth(t *testing.T, terraformOptions *terraform.Options, keyPair *aws.Ec2Keypair) {
//	publicInstanceIP := terraform.Output(t, terraformOptions, "public_ip")
//
//	publicHost := ssh.Host{
//		Hostname:    publicInstanceIP,
//		SshKeyPair:  keyPair.KeyPair,
//		SshUserName: "ubuntu",
//	}
//
//	maxRetries := 30
//	timeBetweenRetries := 5 * time.Second
//	description := fmt.Sprintf("SSH to public host %s", publicInstanceIP)
//
//	// Run a simple echo command on the server
//	expectedText := "200"
//
//	ports := []string{"9100", "9115", "8080"}
//
//	for _, port := range ports {
//		command := fmt.Sprintf("curl -sL -w \"%%{http_code}\" localhost:%s/metrics -o /dev/null", port, )
//
//		description = fmt.Sprintf("SSH to public host %s with error command", publicInstanceIP)
//
//		// Verify that we can SSH to the Instance and run commands
//		retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
//			actualText, err := ssh.CheckSshCommandE(t, publicHost, command)
//
//			if err != nil {
//				return "", err
//			}
//
//			if strings.TrimSpace(actualText) != expectedText {
//				return "", fmt.Errorf("Expected SSH command to return '%s' but got '%s'", expectedText, actualText)
//			}
//
//			return "", nil
//		})
//	}
//}

func testApiEndpoint(t *testing.T, terraformOptions *terraform.Options) {

	nodeIp := terraform.Output(t, terraformOptions, "public_ip")

	expectedStatus := "200"
	body := strings.NewReader(`{
    "jsonrpc": "2.0",
    "id": 1234,
    "method": "icx_call",
    "params": {
        "to": "cx0000000000000000000000000000000000000000",
        "dataType": "call",
        "data": {
            "method": "getPReps",
            "params": {
                "startRanking" : "0x1",
                "endRanking": "0x1"
            }
        }
    }
}`)
	url := fmt.Sprintf("http://%s:9000/api/v3", nodeIp)
	headers := make(map[string]string)
	headers["Content-Type"] = "text/plain"

	description := fmt.Sprintf("curl to node %s with error command", nodeIp)
	maxRetries := 30
	timeBetweenRetries := 1 * time.Second

	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {

		outputStatus, _, err := http_helper.HTTPDoE(t, "POST", url, body, headers, nil)

		if err != nil {
			return "", err
		}

		if strings.TrimSpace(strconv.Itoa(outputStatus)) != expectedStatus {
			return "", fmt.Errorf("expected SSH command to return '%s' but got '%s'", expectedStatus, strconv.Itoa(outputStatus))
		}

		return "", nil
	})
}
