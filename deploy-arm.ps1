az deployment group create --name "checkov-test" -g "rg-checkov-test" -f "keyvault-Prisma.json" -p "keyvault.dev.Prisma.parameters.json" -p "resourceGroupName=rg-checkov-test"
