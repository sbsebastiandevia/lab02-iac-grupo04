# Lab 02 - Infraestructura como Codigo (IaC)

**Curso:** DevOps 26-2
**Grupo:** 04
**Tema:** Comparativa Terraform vs Pulumi desplegando un contenedor Docker local.

---

## Integrantes y roles

| Rol | Nombre | Correo | Responsabilidad |
|-----|--------|--------|-----------------|
| R1 | Nelson Fernando Ferrucho Gonzalez | nferrucho@unal.edu.co | Terraform (`terraform/`) |
| R2 | Juan David Gonzalez Munoz | judgonzalezmu@unal.edu.co | Pulumi (`pulumi/`) |
| R3 | Sebastian Morales Devia | (correo) | Informe comparativo y coordinacion (`docs/`) |

---

## Descripcion

Este proyecto despliega la misma infraestructura local usando dos herramientas
de Infraestructura como Codigo, para compararlas:

- Una **red Docker** dedicada.
- Una **imagen Docker** (Nginx).
- Un **contenedor** que publica el servicio en un puerto del host.

La misma infraestructura esta definida dos veces: con **Terraform** (HCL) y con
**Pulumi** (Python).

---

## Requisitos previos

- **Docker Engine** instalado y corriendo (el socket local debe estar disponible).
- **Terraform** >= 1.5 (para la parte de Terraform).
- **Python** 3.12+ y **Pulumi** CLI (para la parte de Pulumi).

---

## Instrucciones de despliegue local

### Opcion A: Terraform

```bash
cd terraform

# 1. Copiar el archivo de variables de ejemplo y ajustarlo si hace falta
cp terraform.tfvars.example terraform.tfvars

# 2. Inicializar el proveedor
terraform init

# 3. Previsualizar los cambios
terraform plan

# 4. Aplicar (crea la red, la imagen y el contenedor)
terraform apply

# El servicio queda disponible en http://localhost:8080

# 5. Destruir cuando termine
terraform destroy
```

### Opcion B: Pulumi

```bash
cd pulumi

# 1. Crear y activar un entorno virtual
python -m venv venv
source venv/bin/activate        # En Windows: venv\Scripts\activate

# 2. Instalar dependencias
pip install -r requirements.txt

# 3. Seleccionar / crear el stack dev (backend local)
pulumi stack init dev           # solo la primera vez

# 4. Previsualizar
pulumi preview

# 5. Desplegar
pulumi up

# El servicio queda disponible en http://localhost:8080

# 6. Destruir cuando termine
pulumi destroy
```

> Nota: Terraform y Pulumi crean el **mismo** contenedor en el **mismo** puerto
> (8080). No los ejecute simultaneamente sin cambiar el puerto o el nombre, para
> evitar conflictos.

---

## Estructura del repositorio

```
lab02-iac-grupo04/
├── README.md                     # Este archivo
├── .gitignore                    # Excluye tfstate, venv y secretos
├── .github/workflows/iac-ci.yml  # Pipeline Shift-Left (valida PRs)
├── terraform/                    # IaC con Terraform (R1)
├── pulumi/                       # IaC con Pulumi (R2)
└── docs/informe_comparativo.md   # Informe comparativo (R3)
```

---

## Pipeline de CI (Shift-Left)

El workflow `.github/workflows/iac-ci.yml` valida automaticamente cada Pull
Request y push a `main`:
- **Terraform:** `fmt -check`, `init -backend=false` y `validate`.
- **Pulumi:** instalacion de dependencias y validacion de sintaxis del programa.

Esto detecta errores temprano (enfoque Shift-Left), antes de desplegar.
