## GENERATE WSO2AM SERVER APIM TO NEW REPO

Prasyarat Memulai :

- **OKTETO CLI**.
- **Docker Compose**.
- **Kubernetes**

## Tutorial

- Lets get started go to **docs** in order to make your personal namespace by clicking on the following button:

<p align="center">
<a href="https://cloud.okteto.com/deploy">
  <img src="https://okteto.com/develop-okteto.svg" alt="Develop on Okteto">
</a>
</p>

- Clone this repository on **deploy** :

```
  Terminal :
  
  RUN  $ git clone https://github.com/admhabits/generate-wso2-apim.git
  RUN  $ git checkout branch deploy
    
```

- Setup **Working Project Apim** :

```
  Terminal:
  
  RUN $ cd apim && code .
    
```


- Edit **Dockerfile** ARG :

```
ARG REMOTE_NAME=<YOUR_NEW_REPO_NAME>
ARG MY_EMAIL_GIT=<YOUR_EMAIL>
ARG ACCESS_TOKEN=<YOUR_TOKEN_GITHUB>
```
