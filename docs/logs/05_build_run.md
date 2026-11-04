# 커스텀 이미지 빌드 / 포트 매핑 로그

- 실행 시각: 2026-11-04 07:53:54
- 생성: `scripts/05_build_run.sh` 실행 결과 (명령 + 출력 자동 기록)

## 1. Dockerfile 내용

```bash
$ cat /workspaces/E1-1/app/Dockerfile
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
$ cd /workspaces/E1-1/app
$ docker build -t my-web:1.0 .
#0 building with "default" instance using docker driver

#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile:
#1 transferring dockerfile: 1.22kB 0.0s done
#1 DONE 0.2s

#2 [internal] load metadata for docker.io/library/nginx:1.27-alpine
#2 DONE 0.0s

#3 [internal] load .dockerignore
#3 transferring context:
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [internal] load build context
#4 transferring context: 391B done
#4 DONE 0.3s

#5 [1/2] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#5 resolve docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10 0.1s done
#5 DONE 0.5s

#5 [1/2] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#5 extracting sha256:f18232174bc91741fdf3da96d85011092101a032a93a388b79e99e69c2d5c870
#5 extracting sha256:f18232174bc91741fdf3da96d85011092101a032a93a388b79e99e69c2d5c870 1.4s done
#5 DONE 1.8s

#5 [1/2] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#5 extracting sha256:61ca4f733c802afd9e05a32f0de0361b6d713b8b53292dc15fb093229f648674
#5 extracting sha256:61ca4f733c802afd9e05a32f0de0361b6d713b8b53292dc15fb093229f648674 0.9s done
#5 DONE 2.7s

#5 [1/2] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#5 extracting sha256:b464cfdf2a6319875aeb27359ec549790ce14d8214fcb16ef915e4530e5ed235 0.1s done
#5 DONE 2.8s

#5 [1/2] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#5 extracting sha256:d7e5070240863957ebb0b5a44a5729963c3462666baa2947d00628cb5f2d5773
#5 extracting sha256:d7e5070240863957ebb0b5a44a5729963c3462666baa2947d00628cb5f2d5773 0.3s done
#5 extracting sha256:81bd8ed7ec6789b0cb7f1b47ee731c522f6dba83201ec73cd6bca1350f582948
#5 extracting sha256:81bd8ed7ec6789b0cb7f1b47ee731c522f6dba83201ec73cd6bca1350f582948 0.6s done
#5 DONE 3.7s

#5 [1/2] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#5 extracting sha256:197eb75867ef4fcecd4724f17b0972ab0489436860a594a9445f8eaff8155053
#5 extracting sha256:197eb75867ef4fcecd4724f17b0972ab0489436860a594a9445f8eaff8155053 0.2s done
#5 DONE 4.0s

#5 [1/2] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#5 extracting sha256:34a64644b756511a2e217f0508e11d1a572085d66cd6dc9a555a082ad49a3102 0.0s done
#5 extracting sha256:39c2ddfd6010082a4a646e7ca44e95aca9bf3eaebc00f17f7ccc2954004f2a7d
#5 extracting sha256:39c2ddfd6010082a4a646e7ca44e95aca9bf3eaebc00f17f7ccc2954004f2a7d 1.5s done
#5 DONE 5.5s

#6 [2/2] COPY site/ /usr/share/nginx/html/
#6 DONE 2.5s

#7 exporting to image
#7 exporting layers
#7 exporting layers 0.4s done
#7 exporting manifest sha256:fd4c0e1e5989369e2dcb80387b88dc086a58975dc63e2da480f84a0887ac5bff
#7 exporting manifest sha256:fd4c0e1e5989369e2dcb80387b88dc086a58975dc63e2da480f84a0887ac5bff 0.1s done
#7 exporting config sha256:b01914ca124f7706ed6a45b45ce5004582f7f427449c5b653419968330cffdee 0.0s done
#7 exporting attestation manifest sha256:cd55c6f0a8ed1029919ed59e11aa5e5144bfe5bf455644b532c50ea8c0002f21 0.0s done
#7 exporting manifest list sha256:bece07595fb37c2f28ddafa15441b885ac8dd0e36aca63ba93a41a73c24b2893
#7 exporting manifest list sha256:bece07595fb37c2f28ddafa15441b885ac8dd0e36aca63ba93a41a73c24b2893 0.0s done
#7 naming to docker.io/library/my-web:1.0 done
#7 unpacking to docker.io/library/my-web:1.0 0.0s done
#7 DONE 0.6s
$ docker images my-web
IMAGE        ID             DISK USAGE   CONTENT SIZE   EXTRA
my-web:1.0   bece07595fb3       73.6MB           21MB        
```

## 3. 포트 매핑 실행 (같은 이미지로 2개, 호스트 포트만 다르게)

-p 호스트포트:컨테이너포트  (밖:안)

```bash
$ docker run -d -p 8080:80 --name my-web-8080 my-web:1.0
f64a76438a2bd37c5138ac45ad518622a77c771181954457fd0098e2c85c6f4b
$ docker run -d -p 8081:80 --name my-web-8081 my-web:1.0
7d020866989b679f058eb40d04e2bc898174fc06442e109a17893236973aa8c5
$ docker ps --filter name=my-web
CONTAINER ID   IMAGE        COMMAND                  CREATED         STATUS                            PORTS                                     NAMES
7d020866989b   my-web:1.0   "/docker-entrypoint.…"   2 seconds ago   Up 2 seconds (health: starting)   0.0.0.0:8081->80/tcp, [::]:8081->80/tcp   my-web-8081
f64a76438a2b   my-web:1.0   "/docker-entrypoint.…"   2 seconds ago   Up 2 seconds (health: starting)   0.0.0.0:8080->80/tcp, [::]:8080->80/tcp   my-web-8080
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
2026/11/04 07:54:06 [notice] 1#1: using the "epoll" event method
2026/11/04 07:54:06 [notice] 1#1: nginx/1.27.5
2026/11/04 07:54:06 [notice] 1#1: built by gcc 14.2.0 (Alpine 14.2.0) 
2026/11/04 07:54:06 [notice] 1#1: OS: Linux 6.8.0-1064-azure
2026/11/04 07:54:06 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1024:524288
2026/11/04 07:54:06 [notice] 1#1: start worker processes
2026/11/04 07:54:06 [notice] 1#1: start worker process 30
2026/11/04 07:54:06 [notice] 1#1: start worker process 31
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
172.17.0.1 - - [04/Nov/2026:07:54:09 +0000] "GET / HTTP/1.1" 200 261 "-" "curl/8.5.0" "-"
::1 - - [04/Nov/2026:07:54:11 +0000] "GET / HTTP/1.1" 200 261 "-" "Wget" "-"
```

브라우저에서 http://localhost:8080 과 http://localhost:8081 을 열고, 주소창이 보이게 스크린샷 → docs/screenshots/

