# 포트 충돌 진단 및 해제 로그

- 실행 시각: 2026-11-05 15:24:29
- 생성: `scripts/10_port_check.sh` 실행 결과 (명령 + 출력 자동 기록)

## 1. 포트 충돌 재현 (같은 호스트 포트 8085 를 두 번 사용)

```bash
$ docker run -d -p 8085:80 --name port-a nginx:1.27-alpine
57d504bd5a549929e97a150c3bd2321e00bf482240fe10be4deb187da0d16355
```

같은 호스트 포트로 두 번째 컨테이너를 실행 → 실패가 예상됨

```bash
$ docker run -d -p 8085:80 --name port-b nginx:1.27-alpine
c1df3cb88edee1db6b4a4ee080e526e4ee67c5c60370c595d4fa44043c0888f0
docker: Error response from daemon: failed to set up container networking: driver failed programming external connectivity on endpoint port-b (7aeaf84fd0703fda4746a41efd9bbb14608d34364150fc79ee7322a77d15660c): Bind for 0.0.0.0:8085 failed: port is already allocated

Run 'docker run --help' for more information
```

→ 'port is already allocated': 호스트 포트 8085 를 이미 누가 쓰고 있다는 뜻

## 2. 진단: 포트 8085 를 쓰는 컨테이너 찾기

```bash
$ docker ps --filter publish=8085 --format 'table {{.Names}}\t{{.Ports}}\t{{.Status}}'
NAMES     PORTS                                     STATUS
port-a    0.0.0.0:8085->80/tcp, [::]:8085->80/tcp   Up Less than a second
$ docker port port-a
80/tcp -> 0.0.0.0:8085
80/tcp -> [::]:8085
```

실패한 port-b 는 생성만 되고 시작되지 않은 상태(Created)로 남는다

```bash
$ docker ps -a --filter name=port-b --format 'table {{.Names}}\t{{.Status}}'
NAMES     STATUS
port-b    Created
```

## 3. 해제 후 재실행

```bash
$ docker stop port-a
port-a
$ docker rm port-a port-b
port-a
port-b
$ docker run -d -p 8085:80 --name port-b nginx:1.27-alpine
7cf4718c3b037668f358e32baec558760fc5461d953e634330533c83ef4bdb0a
```

응답 상태 코드로 정상 동작 확인 (200 = 성공)

```bash
$ curl -s -o /dev/null -w 'HTTP %{http_code}\n' http://localhost:8085
HTTP 200
$ docker rm -f port-b
port-b
```

## 4. 일반 프로세스가 포트를 점유한 경우 (PID 확인 → kill)

파이썬 간이 웹 서버로 8099 포트를 일부러 점유

백그라운드로 실행한 프로세스 PID: 15552

```bash
$ ss -ltnp | grep ':8099'
LISTEN 0      5             0.0.0.0:8099       0.0.0.0:*    users:(("python3",pid=15552,fd=3))   
$ timeout 3 python3 -m http.server 8099 2>&1 | tail -1
OSError: [Errno 98] Address already in use
```

→ 'Address already in use': 같은 포트를 다른 프로그램이 쓰고 있음

```bash
$ kill 15552
```

해제 확인: '사용하는 프로세스 없음' 이 나오면 포트가 비어 있음

```bash
$ ss -ltnp | grep ':8099' || echo '8099 포트를 사용하는 프로세스 없음'
8099 포트를 사용하는 프로세스 없음
```

