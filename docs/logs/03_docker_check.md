# Docker 설치 및 점검 로그

- 실행 시각: 2026-11-04 07:53:34
- 생성: `scripts/03_docker_check.sh` 실행 결과 (명령 + 출력 자동 기록)

## 1. 버전 확인 (설치되어 있는가?)

```bash
$ docker --version
Docker version 29.9.2-2, build a82e528901260c8df6073311379eac65f92db204
```

## 2. 데몬(엔진) 동작 확인 (실제로 켜져서 응답하는가?)

docker --version 은 설치만 확인. docker info 는 엔진이 살아 있어야 Server 정보가 나온다.

```bash
$ docker info
Client:
 Version:    29.9.2-2
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.38.1
    Path:     /usr/libexec/docker/cli-plugins/docker-buildx
  compose: Docker Compose (Docker Inc.)
    Version:  v5.6.1
    Path:     /usr/libexec/docker/cli-plugins/docker-compose

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 29.9.2-2
 Storage Driver: overlayfs
  driver-type: io.containerd.snapshotter.v1
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
 CDI spec directories:
  /etc/cdi
  /var/run/cdi
 Swarm: inactive
 Runtimes: runc io.containerd.runc.v2
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: b7a25261e029d68978bbf290df0a62fc819b3c51
 runc version: 29dd3dc2b13b4123162e5fe132504bb4b15569f1
 init version: 
 Security Options:
  apparmor
   Profile: default
  seccomp
   Profile: builtin
  cgroupns
 Kernel Version: 6.8.0-1064-azure
 Operating System: Ubuntu 24.04.5 LTS (containerized)
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 7.756GiB
 Name: codespaces-486932
 ID: 744f433d-17d6-4a09-a6ba-e9296e7901b0
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Username: codespacesdev
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
  ::1/128
 Live Restore Enabled: false
 Firewall Backend: iptables
  EnableUserlandProxy: true
  UserlandProxyPath: /usr/libexec/docker/docker-proxy

```

