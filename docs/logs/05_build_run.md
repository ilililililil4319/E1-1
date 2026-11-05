# 커스텀 이미지 빌드 / 포트 매핑 로그

- 실행 시각: 2026-11-05 14:42:32
- 생성: `scripts/05_build_run.sh` 실행 결과 (명령 + 출력 자동 기록)

## 1. Dockerfile 내용

```bash
$ cat /home/ilililililil4319/codyssey/E1-1/app/Dockerfile
# ------------------------------------------------------------
# 방식 (A): 웹 서버 베이스 이미지(NGINX) + 정적 콘텐츠 교체
# ------------------------------------------------------------

# [베이스] 공식 NGINX 이미지(alpine 버전 = 작고 가벼움)
# 태그를 1.27 로 고정 → 언제 빌드해도 같은 버전 (재현성)
FROM nginx:1.27-alpine

# [커스텀 1] LABEL: 이미지에 붙이는 설명 메모 (docker inspect 로 확인 가능)
LABEL org.opencontainers.image.title="e1-1-my-web" \
      org.opencontainers.image.description="Codyssey E1-1 custom nginx image"

# [커스텀 2] ENV: 환경 변수(설정값). 실행 모드를 표시
ENV APP_ENV=dev

# [커스텀 3] COPY: 기본 NGINX 환영 페이지 대신 내 웹페이지로 교체
COPY site/ /usr/share/nginx/html/

# [안내] 이 컨테이너는 80번 포트를 사용 (실제 연결은 docker run -p 가 함)
EXPOSE 80

# [커스텀 4] HEALTHCHECK: 10초마다 웹페이지가 응답하는지 검사
#            docker ps 의 STATUS 에 (healthy) 로 표시됨
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q --spider http://localhost/ || exit 1
```

## 2. 이미지 빌드

-t 이름:태그, 마지막 . = Dockerfile 이 있는 현재 폴더를 빌드 재료(컨텍스트)로 사용

```bash
$ cd /home/ilililililil4319/codyssey/E1-1/app
$ docker build -t my-web:1.0 .
#0 building with "default" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 1.22kB done
#1 DONE 0.1s

#2 [internal] load metadata for docker.io/library/nginx:1.27-alpine
#2 DONE 0.0s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [internal] load build context
#4 transferring context: 333B done
#4 DONE 0.1s

#5 [1/2] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#5 resolve docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10 0.0s done
#5 DONE 0.3s

#5 [1/2] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#5 extracting sha256:f18232174bc91741fdf3da96d85011092101a032a93a388b79e99e69c2d5c870
#5 extracting sha256:f18232174bc91741fdf3da96d85011092101a032a93a388b79e99e69c2d5c870 0.2s done
#5 DONE 0.5s

#5 [1/2] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#5 extracting sha256:61ca4f733c802afd9e05a32f0de0361b6d713b8b53292dc15fb093229f648674
#5 extracting sha256:61ca4f733c802afd9e05a32f0de0361b6d713b8b53292dc15fb093229f648674 0.2s done
#5 DONE 0.6s

#5 [1/2] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#5 extracting sha256:b464cfdf2a6319875aeb27359ec549790ce14d8214fcb16ef915e4530e5ed235 0.0s done
#5 extracting sha256:d7e5070240863957ebb0b5a44a5729963c3462666baa2947d00628cb5f2d5773 0.0s done
#5 extracting sha256:81bd8ed7ec6789b0cb7f1b47ee731c522f6dba83201ec73cd6bca1350f582948 0.0s done
#5 extracting sha256:197eb75867ef4fcecd4724f17b0972ab0489436860a594a9445f8eaff8155053 0.0s done
#5 extracting sha256:34a64644b756511a2e217f0508e11d1a572085d66cd6dc9a555a082ad49a3102 0.0s done
#5 DONE 0.8s

#5 [1/2] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#5 extracting sha256:39c2ddfd6010082a4a646e7ca44e95aca9bf3eaebc00f17f7ccc2954004f2a7d
#5 extracting sha256:39c2ddfd6010082a4a646e7ca44e95aca9bf3eaebc00f17f7ccc2954004f2a7d 0.5s done
#5 DONE 1.3s

#6 [2/2] COPY site/ /usr/share/nginx/html/
#6 DONE 0.1s

#7 exporting to image
#7 exporting layers 0.1s done
#7 exporting manifest sha256:9701358e8acaeb9718ad838511224f9ddba5efa990bb35ec8c357996a4c3e15b 0.0s done
#7 exporting config sha256:e2e5865e33457671c7b5c47dbbe7baa870a7dc88a9eb21447c4da65b1a9420eb 0.0s done
#7 exporting attestation manifest sha256:c18550f4e7df071b6797a74d3226412d3303f39265c916ae8670ae4ec2dc4d51 0.0s done
#7 exporting manifest list sha256:b4547f8e84e705f32445f0d1be77ad7c894d4f48c9de5b721c427275e2bb1bdf
#7 exporting manifest list sha256:b4547f8e84e705f32445f0d1be77ad7c894d4f48c9de5b721c427275e2bb1bdf 0.0s done
#7 naming to docker.io/library/my-web:1.0 done
#7 unpacking to docker.io/library/my-web:1.0 0.0s done
#7 DONE 0.3s
$ docker images my-web
IMAGE        ID             DISK USAGE   CONTENT SIZE   EXTRA
my-web:1.0   b4547f8e84e7       73.6MB           21MB        
```

## 3. 포트 매핑 실행 (같은 이미지로 2개, 호스트 포트만 다르게)

-p 호스트포트:컨테이너포트  (밖:안)

```bash
$ docker run -d -p 8080:80 --name my-web-8080 my-web:1.0
1023fe6d7e330c51df3801f3c3ea07c217a895b018fe7b2fe59f0ff9f2d5a7cc
$ docker run -d -p 8081:80 --name my-web-8081 my-web:1.0
439a78a4c91307e815a205023bc9d46d874da9e3a64efef20f88c9b5af3de207
$ docker ps --filter name=my-web
CONTAINER ID   IMAGE        COMMAND                  CREATED         STATUS                            PORTS                                     NAMES
439a78a4c913   my-web:1.0   "/docker-entrypoint.…"   3 seconds ago   Up 2 seconds (health: starting)   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   my-web-8081
1023fe6d7e33   my-web:1.0   "/docker-entrypoint.…"   3 seconds ago   Up 2 seconds (health: starting)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   my-web-8080
```

## 4. 접속 확인 (curl)

```bash
$ curl -s http://localhost:8080
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>E1-1 My Web</title>
</head>
<body>
  <h1>Hello from my custom NGINX image (E1-1)</h1>
  <p>Dockerfile 로 직접 만든 커스텀 이미지에서 실행 중입니다.</p>
</body>
</html>
$ curl -s http://localhost:8081
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>E1-1 My Web</title>
</head>
<body>
  <h1>Hello from my custom NGINX image (E1-1)</h1>
  <p>Dockerfile 로 직접 만든 커스텀 이미지에서 실행 중입니다.</p>
</body>
</html>
```

## 5. 커스텀 포인트 확인

```bash
$ docker exec my-web-8080 printenv APP_ENV
dev
$ docker inspect -f '{{json .Config.Labels}}' my-web:1.0
{"maintainer":"NGINX Docker Maintainers <docker-maint@nginx.com>","org.opencontainers.image.description":"Codyssey E1-1 custom nginx image","org.opencontainers.image.title":"e1-1-my-web"}
```

헬스체크 결과 (healthy 가 될 때까지 최대 30초 대기)

```bash
$ docker inspect -f '{{.State.Health.Status}}' my-web-8080
healthy
$ docker logs my-web-8080 | tail -5
2026/11/05 05:42:35 [notice] 1#1: using the "epoll" event method
2026/11/05 05:42:35 [notice] 1#1: nginx/1.27.5
2026/11/05 05:42:35 [notice] 1#1: built by gcc 14.2.0 (Alpine 14.2.0) 
2026/11/05 05:42:35 [notice] 1#1: OS: Linux 6.18.54.1-microsoft-standard-WSL2
2026/11/05 05:42:35 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2026/11/05 05:42:35 [notice] 1#1: start worker processes
2026/11/05 05:42:35 [notice] 1#1: start worker process 30
2026/11/05 05:42:35 [notice] 1#1: start worker process 31
2026/11/05 05:42:35 [notice] 1#1: start worker process 32
2026/11/05 05:42:35 [notice] 1#1: start worker process 33
2026/11/05 05:42:35 [notice] 1#1: start worker process 34
2026/11/05 05:42:35 [notice] 1#1: start worker process 35
2026/11/05 05:42:35 [notice] 1#1: start worker process 36
2026/11/05 05:42:35 [notice] 1#1: start worker process 37
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
172.17.0.1 - - [05/Nov/2026:05:42:38 +0000] "GET / HTTP/1.1" 200 261 "-" "curl/8.18.0" "-"
::1 - - [05/Nov/2026:05:42:40 +0000] "GET / HTTP/1.1" 200 261 "-" "Wget" "-"
```

브라우저에서 http://localhost:8080 과 http://localhost:8081 을 열고, 주소창이 보이게 스크린샷 → docs/screenshots/

