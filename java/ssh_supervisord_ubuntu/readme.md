### 基础镜像说明
* [Azul Zulu Enterprise builds of OpenJDK – JDK for Microsoft Azure](https://hub.docker.com/_/microsoft-java-jdk)
* mcr.microsoft.com/java/jdk:8u212-zulu-ubuntu
* 微软官方维护: [https://github.com/microsoft/java](https://github.com/microsoft/java)

### 构建命令
进入到当前目录, 执行以下命令
```bash
docker build -t jdk8_ssh_supervisord:ubuntu .
```

### image 使用示例
```bash
docker run --name docker_1 --hostname docker_1 -v /Users/kk/work/tmp/demo/docker_test/docker_1/deploy:/deploy -v /Users/kk/work/tmp/demo/docker_test/docker_1/supervisor_conf.d:/etc/supervisor/conf.d -p 10001:22 -p 9000:9000 -d jdk8_ssh_supervisord:ubuntu
``` 

#### 目录说明:
* /Users/kk/work/tmp/demo/docker_test
    * 这个目录是Docker宿主机上用于保存不同容器映射目录的
    * **docker_1** 为容器名称
    * **current** 为指向当前版本应用目录的**软连接**

```
docker_test
└── docker_1
    ├── deploy
    │   ├── apache-zookeeper-3.5.5-bin
    │   │   ├── bin
    │   │   ├── conf
    │   │   ├── 其他略...
    │   │
    │   └── api_server
    │       ├── api_server.zip
    │       ├── api_server_20190620
    │       │   ├── bin
    │       │   │   ├── api_server
    │       │   │   └── api_server.bat
    │       │   ├── conf
    │       │   │   ├── application.conf
    │       │   │   ├── logback.xml
    │       │   │   ├── route
    │       │   │   ├── route.websocket
    │       │   │   ├── vertxOptions.json
    │       │   │   └── zookeeper.json
    │       │   └── lib
    │       │       ├── api_server.jar
    │       │       ├── 其他略...
    │       │       
    │       ├── current -> api_server_20190620/
    │       └── logs
    │           └── application.log
    └── supervisor_conf.d   
        └── apps.conf 
```

#### supervisor 配置
* 配置文件: apps.conf 
* 注意: 通过设置环境变量 **JAVA_OPTS** 来设置JVM的参数
```
[program:api_server]
command=/deploy/api_server/current/bin/api_server
directory=/deploy/api_server
environment=JAVA_OPTS="-Xms256m -Xmx2048m"
priority=999
autorestart=false

[program:zookeeper]
command=/deploy/apache-zookeeper-3.5.5-bin/bin/zkServer.sh start-foreground
priority=100
autorestart=true

```
