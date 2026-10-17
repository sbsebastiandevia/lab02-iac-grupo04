# Informe Comparativo: Terraform vs Pulumi

**Lab 02 - Infraestructura como Codigo (IaC) | Grupo 04 | DevOps 26-2**

> Responsabilidad compartida, liderada por R3 (Sebastian Morales Devia).

---

## 1. Objetivo

Desplegar la misma infraestructura local (un contenedor Docker con Nginx,
su red dedicada y la publicacion de un puerto) usando dos herramientas de
IaC distintas, **Terraform** y **Pulumi**, y comparar su enfoque, experiencia
de uso y manejo del estado.

---

## 2. Matriz comparativa

| Criterio | Terraform | Pulumi |
|---|---|---|
| Lenguaje | HCL (declarativo, DSL propio) | Python (lenguaje de proposito general) |
| Provider Docker | kreuzwerker/docker ~> 3.0 | pulumi-docker >= 4.0 |
| Definicion de recursos | Bloques `resource` | Clases y objetos de Python |
| Manejo de estado | Archivo `terraform.tfstate` (local o remoto) | Backend de Pulumi (servicio o local) |
| Configuracion por entorno | `*.tfvars` | `Pulumi.<stack>.yaml` |
| Comando de previsualizacion | `terraform plan` | `pulumi preview` |
| Comando de despliegue | `terraform apply` | `pulumi up` |
| Comando de destruccion | `terraform destroy` | `pulumi destroy` |
| Curva de aprendizaje | Requiere aprender HCL | Aprovecha conocimiento de Python |
| Logica (condicionales, bucles) | Limitada (count, for_each, expresiones) | Completa (toda la potencia de Python) |
| Ecosistema / madurez | Muy amplio, estandar de la industria | Creciente, moderno |

---

## 3. Evidencias de ejecucion

> Completar con las capturas reales tras ejecutar cada herramienta.

### 3.1 Terraform
- [ ] Captura de `terraform plan`
- [ ] Captura de `terraform apply` exitoso
- [ ] Captura del contenedor corriendo (`docker ps`) y del servicio en el navegador
- [ ] Captura de `terraform destroy`

### 3.2 Pulumi
- [ ] Captura de `pulumi preview`
- [ ] Captura de `pulumi up` exitoso
- [ ] Captura del contenedor corriendo y del servicio en el navegador
- [ ] Captura de `pulumi destroy`

---

## 4. Evidencia de Drift

El *drift* (deriva de configuracion) ocurre cuando la infraestructura real
difiere del estado declarado en el codigo. Para evidenciarlo:

1. Desplegar la infraestructura con la herramienta (`apply` / `up`).
2. Modificar manualmente el recurso por fuera de la herramienta, por ejemplo:
   ```bash
   docker stop webapp-grupo04-dev
   # o cambiar el puerto / detener el contenedor manualmente
   ```
3. Volver a ejecutar la deteccion de cambios:
   - Terraform: `terraform plan` (mostrara que el recurso difiere y propondra recrearlo).
   - Pulumi: `pulumi preview` o `pulumi refresh` (detectara la diferencia).
4. Documentar con capturas como cada herramienta **detecta y reporta** la deriva.

> Completar con las capturas del drift detectado por cada herramienta.

---

## 5. Conclusiones

> Completar tras la ejecucion. Puntos sugeridos a desarrollar:
> - Que herramienta resulto mas comoda para el equipo y por que.
> - Diferencias observadas en el manejo del estado y la deteccion de drift.
> - En que escenarios recomendarian Terraform y en cuales Pulumi.
