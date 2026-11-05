# 보너스: Docker Compose 로그

- 실행 시각: 2026-11-05 15:03:40
- 생성: `scripts/09_compose.sh` 실행 결과 (명령 + 출력 자동 기록)

```bash
$ cd /home/ilililililil4319/codyssey/E1-1/compose
$ cat docker-compose.yml
# 보너스: Docker Compose 멀티 컨테이너 + 환경 변수
# 실행: cd compose && docker compose up -d --build
services:
  web:                          # 서비스 1: 내 커스텀 웹 서버
    build: ../app               # app/Dockerfile 로 이미지 빌드
    image: my-web:compose
    environment:
      APP_ENV: ${APP_ENV:-prod} # 환경 변수 주입 (없으면 prod)
    ports:
      - "${WEB_PORT:-8090}:80"  # 호스트 포트도 환경 변수로 변경 가능

  checker:                      # 서비스 2: web 이 살아 있는지 확인하는 보조 컨테이너
    image: alpine:3.20
    depends_on:
      - web
    # 서비스 이름 "web" 으로 접속 = Compose 네트워크의 서비스 디스커버리
    command: sh -c "sleep 3 && wget -qO- http://web/ && sleep infinity"
```

## 1. 실행 (up)

```bash
$ APP_ENV=dev WEB_PORT=8090 docker compose up -d --build
 Image alpine:3.20 Pulling 
 25f1d6b1951a Pulling fs layer 0B
 25f1d6b1951a Downloading 1.049MB
 25f1d6b1951a Downloading 2.097MB
 25f1d6b1951a Downloading 3.146MB
 25f1d6b1951a Download complete 0B
 3a030ca3f633 Download complete 0B
 d4050d56ebf2 Download complete 0B
 25f1d6b1951a Extracting 1B
 25f1d6b1951a Pull complete 0B
 Image alpine:3.20 Pulled 
 Image my-web:compose Building 
#1 [internal] load local bake definitions
#1 reading from stdin 523B done
#1 DONE 0.0s

#2 [internal] load build definition from Dockerfile
#2 transferring dockerfile: 1.22kB done
#2 DONE 0.0s

#3 [internal] load metadata for docker.io/library/nginx:1.27-alpine
#3 DONE 0.0s

#4 [internal] load .dockerignore
#4 transferring context: 2B done
#4 DONE 0.0s

#5 [internal] load build context
#5 transferring context: 61B done
#5 DONE 0.0s

#6 [1/2] FROM docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10
#6 resolve docker.io/library/nginx:1.27-alpine@sha256:65645c7bb6a0661892a8b03b89d0743208a18dd2f3f17a54ef4b76fb8e2f2a10 0.0s done
#6 DONE 0.0s

#7 [2/2] COPY site/ /usr/share/nginx/html/
#7 CACHED

#8 exporting to image
#8 exporting layers done
#8 exporting manifest sha256:322432a53c2647684f88bd96471c5a993051cbcd2b4bb9716674adbe63b0cc32 0.0s done
#8 exporting config sha256:ae5a023c24ae4a3a39424df04c59f1a4a27c1a745b65a692486165c4560681dc 0.0s done
#8 exporting attestation manifest sha256:c45780bb89c6c95ae90ad8c06d837de9f778be719a6b80a74697d4a8d833a113 0.0s done
#8 exporting manifest list sha256:b57c47d68c70539ce73d8af566d53160bb9b74ebb65638ab5e53a6c069ea71c0 0.0s done
#8 naming to docker.io/library/my-web:compose
#8 naming to docker.io/library/my-web:compose done
#8 unpacking to docker.io/library/my-web:compose done
#8 DONE 0.1s

#9 resolving provenance for metadata file
#9 DONE 0.0s
 Image my-web:compose Built 
 Network compose_default Creating 
 Network compose_default Creating 
 Network compose_default Created 
 Network compose_default Created 
 Container compose-web-1 Creating 
 Container compose-web-1 Created 
 Container compose-checker-1 Creating 
 Container compose-checker-1 Created 
 Container compose-web-1 Starting 
 Container compose-web-1 Started 
 Container compose-checker-1 Starting 
 Container compose-checker-1 Started 
```

## 2. 상태 (ps)

```bash
$ docker compose ps
NAME                IMAGE            COMMAND                  SERVICE   CREATED         STATUS                   PORTS
compose-checker-1   alpine:3.20      "sh -c 'sleep 3 && w…"   checker   6 seconds ago   Up 5 seconds             
compose-web-1       my-web:compose   "/docker-entrypoint.…"   web       6 seconds ago   Up 5 seconds (healthy)   0.0.0.0:8090->80/tcp, [::]:8090->80/tcp
```

## 3. 컨테이너 간 통신 확인 (checker → web)

```bash
$ docker compose logs checker
checker-1  | <!DOCTYPE html>
checker-1  | <html lang="ko">
checker-1  | <head>
checker-1  |   <meta charset="UTF-8">
checker-1  |   <title>E1-1 My Web</title>
checker-1  | </head>
checker-1  | <body>
checker-1  |   <h1>Hello from my custom NGINX image (E1-1)</h1>
checker-1  |   <p>Dockerfile 로 직접 만든 커스텀 이미지에서 실행 중입니다.</p>
checker-1  | </body>
checker-1  | </html>
$ docker compose exec web printenv APP_ENV
dev
$ curl -s http://localhost:8090
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

## 4. 로그 (logs)

```bash
$ docker compose logs web | tail -5
web-1  | 2026/11/05 06:03:45 [notice] 1#1: start worker process 36
web-1  | 2026/11/05 06:03:45 [notice] 1#1: start worker process 37
web-1  | 172.18.0.3 - - [05/Nov/2026:06:03:49 +0000] "GET / HTTP/1.1" 200 261 "-" "Wget" "-"
web-1  | ::1 - - [05/Nov/2026:06:03:50 +0000] "GET / HTTP/1.1" 200 261 "-" "Wget" "-"
web-1  | 172.18.0.1 - - [05/Nov/2026:06:03:51 +0000] "GET / HTTP/1.1" 200 261 "-" "curl/8.18.0" "-"
```

## 5. 종료 (down)

```bash
$ docker compose down
 Container compose-checker-1 Stopping 
 Container compose-checker-1 Stopped 
 Container compose-checker-1 Removing 
 Container compose-checker-1 Removed 
 Container compose-web-1 Stopping 
 Container compose-web-1 Stopped 
 Container compose-web-1 Removing 
 Container compose-web-1 Removed 
 Network compose_default Removing 
 Network compose_default Removed 
$ docker compose ps
NAME      IMAGE     COMMAND   SERVICE   CREATED   STATUS    PORTS
```

