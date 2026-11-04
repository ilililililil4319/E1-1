# 바인드 마운트 반영 로그

- 실행 시각: 2026-11-04 07:54:11
- 생성: `scripts/06_bind_mount.sh` 실행 결과 (명령 + 출력 자동 기록)

```bash
$ cd /workspaces/E1-1/bind-mount
$ mkdir -p site
```

## 1. 변경 전: 호스트 파일 작성

```bash
$ echo '<h1>Before: bind mount test</h1>' > site/index.html
$ cat site/index.html
<h1>Before: bind mount test</h1>
```

## 2. 호스트 폴더를 컨테이너에 연결해서 실행

-v 호스트절대경로:컨테이너경로 / $(pwd) = 현재 폴더 절대 경로

```bash
$ docker run -d -p 8082:80 --name bind-test -v "$(pwd)/site":/usr/share/nginx/html nginx:1.27-alpine
c126e4ec0fea3a05fddc9d259daf3d537336d87bbf1247cdff6aff4331d40952
$ curl -s http://localhost:8082
<h1>Before: bind mount test</h1>
```

## 3. 변경 후: 호스트에서만 파일 수정 (재빌드/재시작 없음)

```bash
$ echo '<h1>After: changed on host!</h1>' > site/index.html
$ curl -s http://localhost:8082
<h1>After: changed on host!</h1>
```

→ 컨테이너를 다시 만들지 않았는데도 내용이 바뀌었다 = 바인드 마운트로 호스트 폴더를 그대로 공유

## 4. 연결 정보 확인

```bash
$ docker inspect -f '{{range .Mounts}}{{.Type}}: {{.Source}} -> {{.Destination}}{{end}}' bind-test
bind: /workspaces/E1-1/bind-mount/site -> /usr/share/nginx/html
$ docker rm -f bind-test
bind-test
```

