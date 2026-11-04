# Docker 운영 / 컨테이너 실행 로그

- 실행 시각: 2026-11-04 07:53:35
- 생성: `scripts/04_docker_ops.sh` 실행 결과 (명령 + 출력 자동 기록)

## 1. 이미지 다운로드 / 목록

```bash
$ docker pull ubuntu:24.04
24.04: Pulling from library/ubuntu
7a48b8f0e5c7: Pulling fs layer
7a48b8f0e5c7: Download complete
98144013299c: Download complete
7a48b8f0e5c7: Pull complete
Digest: sha256:fe81560990fae86dc4743202b2cb4d3df98d0bcf949173cecef15ce1127ef852
Status: Downloaded newer image for ubuntu:24.04
docker.io/library/ubuntu:24.04
$ docker pull nginx:1.27-alpine
1.27-alpine: Pulling from library/nginx
61ca4f733c80: Pulling fs layer
81bd8ed7ec67: Pulling fs layer
39c2ddfd6010: Pulling fs layer
197eb75867ef: Pulling fs layer
d7e507024086: Pulling fs layer
f18232174bc9: Pulling fs layer
34a64644b756: Pulling fs layer
b464cfdf2a63: Pulling fs layer
b464cfdf2a63: Download complete
81bd8ed7ec67: Download complete
61ca4f733c80: Download complete
d7e507024086: Download complete
39c2ddfd6010: Download complete
f18232174bc9: Download complete
197eb75867ef: Download complete
34a64644b756: Download complete
f18232174bc9: Pull complete
2a84448aca9c: Download complete
61ca4f733c80: Pull complete
b464cfdf2a63: Pull complete
81bd8ed7ec67: Pull complete
d7e507024086: Pull complete
197eb75867ef: Pull complete
34a64644b756: Pull complete
9261b9aff737: Download complete
39c2ddfd6010: Pull complete
Digest: sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
Status: Downloaded newer image for nginx:1.27-alpine
docker.io/library/nginx:1.27-alpine
$ docker images
IMAGE               ID             DISK USAGE   CONTENT SIZE   EXTRA
nginx:1.27-alpine   65645c7bb6a0       74.5MB         21.9MB        
ubuntu:24.04        fe81560990fa        119MB         31.7MB        
```

## 2. hello-world 실행

이미지가 없으면 자동 pull → 컨테이너 생성 → 메시지 출력 → 할 일이 끝나 종료(Exited)

```bash
$ docker run --name hello hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
4f55086f7dd0: Pulling fs layer
4f55086f7dd0: Download complete
4f55086f7dd0: Pull complete
d5e71e642bf5: Download complete
Digest: sha256:c567b231f65614688711a75f31518a064258a51d442117a3e771a3a8fdba78ef
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

```

## 3. 컨테이너 목록: 실행 중(ps) vs 전체(ps -a)

```bash
$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

hello-world 는 이미 종료되어 docker ps 에는 없고 docker ps -a 에만 보인다.

```bash
$ docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED         STATUS                              PORTS     NAMES
082535bba6b7   hello-world   "/hello"   3 seconds ago   Exited (0) Less than a second ago             hello
```

## 4. 실행 / 로그 / 리소스 / 중지

```bash
$ docker run -d --name ops-nginx nginx:1.27-alpine
e8aa521000132fdfc0ea252eb036d7a30b216d3111c4eebe19b898234023236a
$ docker ps
CONTAINER ID   IMAGE               COMMAND                  CREATED                  STATUS                  PORTS     NAMES
e8aa52100013   nginx:1.27-alpine   "/docker-entrypoint.…"   Less than a second ago   Up Less than a second   80/tcp    ops-nginx
$ docker logs ops-nginx
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2026/11/04 07:53:50 [notice] 1#1: using the "epoll" event method
2026/11/04 07:53:50 [notice] 1#1: nginx/1.27.5
2026/11/04 07:53:50 [notice] 1#1: built by gcc 14.2.0 (Alpine 14.2.0) 
2026/11/04 07:53:50 [notice] 1#1: OS: Linux 6.8.0-1064-azure
2026/11/04 07:53:50 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1024:524288
2026/11/04 07:53:50 [notice] 1#1: start worker processes
2026/11/04 07:53:50 [notice] 1#1: start worker process 31
2026/11/04 07:53:50 [notice] 1#1: start worker process 32
$ docker stats --no-stream ops-nginx
CONTAINER ID   NAME        CPU %     MEM USAGE / LIMIT     MEM %     NET I/O      BLOCK I/O     PIDS
e8aa52100013   ops-nginx   0.00%     3.031MiB / 7.756GiB   0.04%     732B / 84B   0B / 8.19kB   3
$ docker stop ops-nginx
ops-nginx
$ docker ps -a --filter name=ops-nginx
CONTAINER ID   IMAGE               COMMAND                  CREATED         STATUS                              PORTS     NAMES
e8aa52100013   nginx:1.27-alpine   "/docker-entrypoint.…"   2 seconds ago   Exited (0) Less than a second ago             ops-nginx
$ docker start ops-nginx
ops-nginx
$ docker ps --filter name=ops-nginx
CONTAINER ID   IMAGE               COMMAND                  CREATED         STATUS                  PORTS     NAMES
e8aa52100013   nginx:1.27-alpine   "/docker-entrypoint.…"   2 seconds ago   Up Less than a second   80/tcp    ops-nginx
$ docker rm -f ops-nginx
ops-nginx
```

## 5. ubuntu 컨테이너 안에서 명령 실행

대화형(-it) 진입은 수동으로 수행 → README '수동 실습' 참고. 여기서는 같은 명령을 비대화형으로 기록.

```bash
$ docker run --rm ubuntu:24.04 bash -c 'ls / && echo hello-from-ubuntu'
bin
boot
dev
etc
home
lib
lib64
media
mnt
opt
proc
root
run
sbin
srv
sys
tmp
usr
var
hello-from-ubuntu
```

## 6. exec 관찰: exec 로 들어갔다 나와도 컨테이너는 계속 실행

```bash
$ docker run -dit --name obs-ubuntu ubuntu:24.04 bash
b7e5119e9612f3918bdcef33f46065ecd257e4b28cb5ee093b9906048abe9b58
$ docker exec obs-ubuntu bash -c 'echo inside-by-exec && hostname'
inside-by-exec
b7e5119e9612
$ docker ps --filter name=obs-ubuntu
CONTAINER ID   IMAGE          COMMAND   CREATED        STATUS                  PORTS     NAMES
b7e5119e9612   ubuntu:24.04   "bash"    1 second ago   Up Less than a second             obs-ubuntu
```

exec 는 새 프로세스를 따로 열기 때문에, 그 프로세스가 끝나도 메인 프로세스(bash)는 살아 있다 → 상태 Up 유지.

attach 는 메인 프로세스에 직접 붙으므로 거기서 exit 하면 컨테이너가 종료된다 (수동 실습으로 확인).

