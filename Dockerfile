# Usa la imagen base de Apache Airflow
FROM apache/airflow:2.9.1

# Establecer la variable de entorno para no crear directorio __pycache__
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

ENV TZ=America/Bogota

# Instala dependencias necesarias para el WebDriver
USER root

RUN apt-get update && \
    apt-get install -y \
    wget \
    software-properties-common \
    unzip \
    gnupg && \
    apt-get clean

# Añade el repositorio y clave para Microsoft Edge
RUN wget -q -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    install -o root -g root -m 644 microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list' && \
    rm microsoft.asc.gpg

# Instala Microsoft Edge y el Edge WebDriver
RUN apt-get update && \
    apt-get install -y microsoft-edge-stable && \
    apt-get clean

# Descarga y extrae el Edge WebDriver
RUN EDGE_VERSION=$(microsoft-edge --version | grep -oP "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+") && \
    wget https://msedgedriver.azureedge.net/$EDGE_VERSION/edgedriver_linux64.zip && \
    unzip edgedriver_linux64.zip && \
    mv msedgedriver /usr/local/bin/ && \
    rm edgedriver_linux64.zip

# # Copiar el archivo requirements.txt a la carpeta airflow
# COPY requirements.txt /opt/airflow/requirements.txt

# # Moverse a la carpeta airflow y crear un entorno virtual
# WORKDIR /opt/airflow
# RUN python3 -m venv venv

# # Activar el entorno virtual y instalar las dependencias listadas en requirements.txt
# RUN . venv/bin/activate && pip install --no-cache-dir -r requirements.txt

# Establecer el usuario para evitar problemas de permisos
USER airflow


RUN pip install \
    xlwings==0.29.1 \
    openpyxl==3.1.2 \
    xlrd==2.0.1 \
    oracledb==2.1.2 \
    selenium==4.18.1 \
    holidays==0.49 \
    apache-airflow-providers-microsoft-mssql \
    apache-airflow-providers-oracle \
    apache-airflow-providers-telegram