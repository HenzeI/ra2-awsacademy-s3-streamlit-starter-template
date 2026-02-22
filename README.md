# Proyecto RA2: Dashboard IoT con Streamlit y S3

## Descripción
Este proyecto implementa un flujo completo de datos IoT en AWS:

1. Generación/ingesta de datos en formato JSON.
2. Almacenamiento en un bucket S3 privado.
3. Lectura desde una aplicación Streamlit.
4. Visualización y filtrado de datos en un dashboard web.
5. Despliegue en una instancia EC2 accesible por navegador.

La app está pensada para el entorno de AWS Academy, usando buenas prácticas de seguridad (sin claves en el repositorio).

## Estructura de carpetas
```text
  ra2-awsacademy-s3-streamlit-starter-template/
  │
  ├── app/
  │   ├── dashboard.py
  │   └── services/
  │       ├── preprocessing.py
  │       └── s3_loader.py
  │
  ├── docs/
  │   ├── decisiones.md
  │   ├── entrega.md
  │   ├── enunciado.md
  │   ├── evidencias.md
  │   └── capturas/
  │
  ├── notebooks/
  │   └── generar_y_subir_iabd05_sensores.ipynb
  │
  ├── scripts/
  │   ├── healthcheck.sh
  │   ├── ec2_setup.sh
  │   └── run_streamlit_nohup.sh
  │
  ├── .gitignore
  └── README.md
```

## Características del dashboard
El dashboard (`app/dashboard.py`) incluye:

- Carga de datos JSON desde S3 (bucket y key configurables).
- Normalización y preprocesado de columnas.
- Filtro por estado del sensor (`OK`, `WARN`, `FAIL` o todos).
- Filtro por rango de temperatura.
- Tabla de registros filtrados.
- Gráfica de línea: temperatura en el tiempo por sensor.
- Gráfica de barras: CO2 agregado por sensor.
- Mapa de sensores con `lat/lon`.
- Caché de datos y botón de recarga.

## Funcionamiento de los scripts

### `scripts/ec2_setup.sh`
Prepara el entorno en EC2:

1. Instala dependencias del sistema (`python3-pip`, `python3-venv`, `git`).
2. Crea entorno virtual `.venv`.
3. Instala dependencias de Python desde `requirements.txt`.
4. Verifica que Streamlit está instalado.

### `scripts/run_streamlit_nohup.sh`
Arranca el dashboard en segundo plano:

1. Se posiciona en la raíz del repo.
2. Activa `.venv` si existe.
3. Ejecuta Streamlit con `nohup` para que siga corriendo al cerrar SSH.
4. Expone por defecto `0.0.0.0:8501`.
5. Guarda logs en `streamlit.log`.

Variables opcionales:

- `PORT` (por defecto `8501`)
- `ADDR` (por defecto `0.0.0.0`)

## Despliegue en EC2 por SSH (AWS)
El despliegue se hace conectando por SSH a la instancia EC2.

Ejemplo de flujo:

```bash
ssh -i <tu-clave.pem> ubuntu@<IP_PUBLICA_EC2>
git clone <url-del-repo>
cd <repo>

chmod +x scripts/ec2_setup.sh
chmod +x scripts/run_streamlit_nohup.sh

bash scripts/ec2_setup.sh

# Definir configuracion S3
export AWS_REGION=<region>
export S3_BUCKET=<bucket>
export S3_KEY=data/sensores/iabd05_sensores.json

# Arrancar app
bash scripts/run_streamlit_nohup.sh
```

Luego se accede desde el navegador:

```text
http://IP_PUBLICA_EC2:8501
```

## Seguridad y credenciales
- No subir claves AWS, tokens, `.pem` ni `.env` con secretos.
- Acceso recomendado a S3: `aws configure` en EC2 (sin versionar credenciales).

## Autor
- [Hancel Fernando Abrines Vasallo](https://github.com/daydroidmuchiri)