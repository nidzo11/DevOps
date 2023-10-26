# Run terraform apply
terraform apply -auto-approve

# If terraform apply was successful, save outputs to a temporary file
if ($?) {
    Write-Host "Terraform apply completed successfully."
    $outputJson = terraform output -json
    $outputJson | Out-File -Encoding utf8 C:/Mywork/DevOps/ansible/inventory/temp_outputs.json
    Write-Host "Saved outputs to temp_outputs.json"
} else {
    Write-Host "Terraform apply failed."
}
