# Informe Comparativo: Terraform vs. Pulumi

**Laboratorio 02 - IaC: Terraform vs. Pulumi | Fundamentos de DevOps y SRE**

## Grupo: grupo04

### Integrantes:

- **Nelson Fernando Ferrucho Gonzalez** - R1 (Terraform)
- **Juan David Gonzalez Munoz** - R2 (Pulumi)
- **Sebastian Morales Devia** - R3 (Platform Lead)

---

## 7.1 Matriz de Comparacion Empirica

| Criterio de Comparacion | Terraform (HCL) | Pulumi (Python) | Analisis del Grupo con Evidencia Observada |
|---|---|---|---|
| **1. Curva de aprendizaje y sintaxis** | DSL declarativo especializado | Lenguaje general orientado a objetos | R1 configuro el contenedor mas rapido: HCL es declarativo y directo, no exige saber programar. R2 necesito manejar conceptos de Python (objetos, imports). Para quien ya programa en Python, Pulumi se sintio natural; para infraestructura pura, HCL fue mas veloz de arrancar. |
| **2. Lineas de codigo efectivas (LOC)** | ~48 lineas (main.tf) | ~60 lineas (__main__.py) | Excluyendo comentarios y lineas en blanco, Terraform resulto mas compacto para el mismo resultado. Pulumi agrega boilerplate de Python (imports, construccion de objetos Args, validacion manual), lo que incrementa el conteo. |
| **3. Manejo del Estado (State)** | Archivo `terraform.tfstate` local | Metadatos de Stack local en `~/.pulumi` | En Terraform el estado es un unico archivo JSON (`terraform.tfstate`) facil de abrir e inspeccionar. En Pulumi el estado vive en el backend (local `file://~`), consultable con `pulumi stack`. Terraform fue mas transparente para ver a ojo que recursos existen; Pulumi lo abstrae tras comandos. |
| **4. Validacion de variables y tipos** | Bloque `validation { condition = ... }` | Logica en Python (`if ... raise ValueError`) | Terraform valida declarativamente dentro de `variable` (ej. ambiente debe ser dev/staging/prod) y falla en `plan`/`apply` con mensaje claro. Pulumi valida con codigo Python (`if environment not in valid_envs: raise ValueError`), detectando el error al ejecutar. Ambos detectan temprano; Terraform da el mensaje mas estandarizado. |
| **5. Deteccion y correccion de Drift** | `terraform plan` | `pulumi preview --refresh` | Al borrar el contenedor manualmente con `docker rm -f`, ambas herramientas detectaron la deriva. **Terraform:** `terraform plan` reporto el contenedor eliminado y planeo recrearlo (`Plan: 1 to add`). **Pulumi:** `pulumi preview --refresh` mostro `network` e `image` intactos (unchanged) y el `container-grupo04` como `+ create` (`+ 1 to create, 3 unchanged`). Las dos reconcilian el estado real contra el codigo. |
| **6. Multiplicidad y ciclos** | Meta-argumento `count` / `for_each` | Bucle estandar `for` en listas Python | Para crear N replicas, Pulumi resulto mas legible al usar un `for` nativo de Python (familiar para cualquier desarrollador). Terraform usa `count`/`for_each`, potentes pero con una sintaxis mas especifica del DSL que requiere aprenderse. |
| **7. Ecosistema de Linters / Shift-Left** | `terraform fmt`, `terraform validate` | `ruff`, `flake8` | En el pipeline de CI (GitHub Actions), el gate de Terraform (`fmt -check` + `validate`) fue muy rapido y detecto de inmediato problemas de formato (de hecho rechazo el primer push por formato no canonico). El gate de Pulumi (Ruff + Flake8) analiza el codigo Python. Ambos quality gates se ejecutan en paralelo en cada PR (enfoque Shift-Left). |

---

## 2. Evidencias de la practica

### 2.1 Terraform (R1 + R3)
- `terraform init` y `terraform apply -auto-approve`: creacion exitosa de 3 recursos (red, imagen Nginx, contenedor). Salida: `Apply complete! Resources: 3 added, 0 changed, 0 destroyed.`
- Contenedor `servidor-web-grupo04-tf` corriendo y servicio Nginx accesible en `http://127.0.0.1:8085`.
- **Drift:** `docker rm -f servidor-web-grupo04-tf` -> `terraform plan` detecta el contenedor eliminado y planea recrearlo.

### 2.2 Pulumi (R2 + R3)
- Stack `lab02-iac-pulumi-dev` con 3 recursos (red, imagen Nginx, contenedor `servidor-web-grupo04-pulumi`, puerto 8090).
- **Drift:** tras eliminar el contenedor, `pulumi preview --refresh` muestra: `network-grupo04` y `nginx-image-grupo04` sin cambios (refresh), `container-grupo04` marcado como `+ create`. Resultado: `+ 1 to create, 3 unchanged`.

### 2.3 Pipeline CI (R3)
- Workflow `.github/workflows/iac-ci.yml` con dos quality gates (Terraform y Pulumi) que corren en cada Pull Request y push a `main`.

---

## 3. Destruccion Limpia Verificada ($0 Residuos)

- **Terraform:** `terraform destroy -auto-approve` -> se elimina el contenedor y la red. Verificado con `docker ps` (sin `servidor-web-grupo04-tf`) y `docker network ls` (sin la red).
- **Pulumi:** `pulumi destroy --yes` -> se eliminan los recursos del stack.

> Nota: el enunciado usa `grupo01` como ejemplo; los nombres reales de este grupo son `servidor-web-grupo04-tf` (Terraform) y `servidor-web-grupo04-pulumi` (Pulumi).

---

## 4. Conclusiones

- **Terraform** destaco por su concision y transparencia del estado: menos lineas, estado en un archivo inspeccionable y un `fmt`/`validate` muy rapidos en CI. Ideal cuando el foco es puramente infraestructura declarativa.
- **Pulumi** destaco por aprovechar un lenguaje de proposito general (Python): la logica (validaciones, bucles) se siente natural para quien ya programa, a costa de algo mas de boilerplate.
- **Ambos detectan drift de forma efectiva:** al alterar la infraestructura por fuera del codigo, las dos herramientas reconciliaron el estado real contra el deseado y propusieron recrear el recurso eliminado, demostrando el valor central de la IaC.
- **Recomendacion del grupo:** Terraform para equipos centrados en infraestructura y maxima legibilidad declarativa; Pulumi para equipos de desarrollo que prefieren reutilizar su conocimiento de un lenguaje de programacion y necesitan logica compleja.
