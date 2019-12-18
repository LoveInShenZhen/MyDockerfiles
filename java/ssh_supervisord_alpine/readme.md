### 构建命令
```bash
docker build -t dragonsunmoon/jdk8_ssh_supervisord:latest .
```

### image 使用示例
```bash
docker run --name docker_2 --hostname docker_2 --net=kk-dev -v /Users/kk/work/tmp/demo/docker_test/docker_1/deploy:/deploy -v /Users/kk/work/tmp/demo/docker_test/docker_1/supervisor_conf.d:/etc/supervisor/conf.d -p 10002:22 -p 9000:9000 -d dragonsunmoon/jdk8_ssh_supervisord:latest

```



