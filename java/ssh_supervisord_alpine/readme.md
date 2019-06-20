### 构建命令
```bash
docker build -t jdk8_ssh_supervisord:latest .
```

### image 使用示例
```bash
docker run --name api_server --hostname api_server -v /Users/kk/work/tmp/demo/docker_test:/work -v /Users/kk/work/tmp/demo/docker_test/conf.d:/etc/supervisor/conf.d -p 10001:22 -p 9000:9000 -d jdk8_ssh_supervisord:latest

```



