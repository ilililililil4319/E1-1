#!/usr/bin/env bash
# Docker 볼륨 영속성: 컨테이너를 지워도 데이터가 남는지 검증
source "$(dirname "$0")/lib.sh"
require_docker
docker rm -f vol-test vol-test2 > /dev/null 2>&1
docker volume rm mydata > /dev/null 2>&1
start_log "07_volume.md" "Docker 볼륨 영속성 로그"

section "1. 볼륨 생성"
run "docker volume create mydata"
run "docker volume ls"
run "docker volume inspect mydata"

section "2. 볼륨 연결 + 데이터 쓰기"
note "sleep infinity = 할 일이 없어 바로 꺼지지 않도록 계속 대기"
run "docker run -d --name vol-test -v mydata:/data ubuntu:24.04 sleep infinity"
run "docker exec vol-test bash -lc 'echo hi > /data/hello.txt && cat /data/hello.txt'"

section "3. 컨테이너 삭제 (삭제 전/후 목록)"
run "docker ps -a --filter name=vol-test"
run "docker rm -f vol-test"
run "docker ps -a --filter name=vol-test"

section "4. 새 컨테이너에 같은 볼륨 연결 → 데이터 확인"
run "docker run -d --name vol-test2 -v mydata:/data ubuntu:24.04 sleep infinity"
run "docker exec vol-test2 bash -lc 'cat /data/hello.txt'"
note "→ 컨테이너는 지웠지만 hi 가 그대로 = 볼륨 데이터 영속성 증명"
run "docker rm -f vol-test2"
