# Terraform VPC Project

Este proyecto implementa una infraestructura modular de AWS usando Terraform. Incluye una red VPC, subred pública, y está preparada para integración continua con GitHub Actions utilizando autenticación OIDC segura.

## 🏗️ Estructura del Proyecto

```
terraform-vpc-project/
├── modules/
│   ├── vpc/              # Módulo reutilizable para VPC
│   └── subnet/           # Módulo reutilizable para subred pública
├── environments/
│   ├── dev/              # Entorno dev con backend remoto (S3 + DynamoDB)
└── .github/workflows/    # CI/CD GitHub Actions (fase 3)
```

## 🧰 Requisitos

- [Terraform ≥ 1.5.x](https://www.terraform.io/downloads)
- [AWS CLI ≥ 2.x](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- Cuenta de AWS con permisos para VPC, EC2, IAM, DynamoDB y S3
- Perfil local: `terraform-training`

## 🔐 Backend Remoto

Este proyecto usa:

- **S3** para almacenar el `terraform.tfstate`
- **DynamoDB** para locking y evitar race conditions

> Ambos recursos deben crearse manualmente antes del `terraform init`.

## 🧪 Primeros pasos (para `environments/dev/`)

```bash
cd environments/dev/
terraform init -backend-config="profile=terraform-training"
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

## 🔁 Variables

Consulta `terraform.tfvars.example` como plantilla para definir tus variables por entorno.

## 🔧 Despliegue automático con GitHub Actions

- El repositorio está preparado para usar autenticación OIDC con AWS
- Al hacer push o PR a `main`, se ejecutan:
  - `terraform fmt`
  - `terraform validate`
  - `terraform plan`
  - `terraform apply` (en ramas protegidas con aprobación)

> El rol de GitHub Actions debe estar configurado en AWS con el proveedor OIDC:  
> `token.actions.githubusercontent.com`

## 🛡️ Seguridad

- Política de IAM restringida por organización/repo/rama
- Secretos y claves nunca se suben (se usan `terraform.tfvars` locales o SSM)
- CI/CD autenticado de forma segura con credenciales temporales (OIDC)

## 📦 Roadmap

✅ Fase 1 – Fundamentos  
✅ Fase 2 – Modularización + Backend  
🚧 Fase 3 – CI/CD con GitHub Actions  
🔜 Fase 4 – Seguridad Avanzada + Multi-Cuenta  
🔜 Fase 5 – EKS + despliegue de aplicaciones


# Extra

## Crear el bucket para almacenar el estado de terraform
aws s3api create-bucket --bucket terraform-remote-state-sebastian-2 --region us-east-1 --profile terraform-training

## Crear la tabla de dynamoDB para almacenar el locking
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
  --profile terraform-training

## Vaciar el bucket
aws s3 rm s3://terraform-remote-state-sebastian-2 --recursive --profile terraform-training

## Eliminar el bucket
aws s3api delete-bucket --bucket terraform-remote-state-sebastian-2 --region us-east-1 --profile terraform-training

## Eliminar tabla
aws dynamodb delete-table --table-name terraform-locks --profile terraform-training
