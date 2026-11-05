# Docker 볼륨 영속성 로그

- 실행 시각: 2026-11-05 14:42:46
- 생성: `scripts/07_volume.sh` 실행 결과 (명령 + 출력 자동 기록)

## 1. 볼륨 생성

```bash
$ docker volume create mydata
mydata
$ docker volume ls
DRIVER    VOLUME NAME
local     mydata
$ docker volume inspect mydata
[
    {
        "CreatedAt": "2026-11-05T05:42:46Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/mydata/_data",
        "Name": "mydata",
        "Options": null,
        "Scope": "local"
    }
]
```

## 2. 볼륨 연결 + 데이터 쓰기

sleep infinity = 할 일이 없어 바로 꺼지지 않도록 계속 대기

```bash
$ docker run -d --name vol-test -v mydata:/data ubuntu:24.04 sleep infinity
9e74d1f20d23f33579a40f441fb11ca15ddb1d45f88ed9bcff64a09ca6ef5c5c
$ docker exec vol-test bash -lc 'echo hi > /data/hello.txt && cat /data/hello.txt'
hi
```

## 3. 컨테이너 삭제 (삭제 전/후 목록)

```bash
$ docker ps -a --filter name=vol-test
CONTAINER ID   IMAGE          COMMAND            CREATED        STATUS                  PORTS     NAMES
9e74d1f20d23   ubuntu:24.04   "sleep infinity"   1 second ago   Up Less than a second             vol-test
$ docker rm -f vol-test
vol-test
$ docker ps -a --filter name=vol-test
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

## 4. 새 컨테이너에 같은 볼륨 연결 → 데이터 확인

```bash
$ docker run -d --name vol-test2 -v mydata:/data ubuntu:24.04 sleep infinity
8ff7174261be21d2045434a66ac1ce3d30dc91ddf276e48612f3ad5c42344750
$ docker exec vol-test2 bash -lc 'cat /data/hello.txt'
hi
```

→ 컨테이너는 지웠지만 hi 가 그대로 = 볼륨 데이터 영속성 증명

```bash
$ docker rm -f vol-test2
vol-test2
```

