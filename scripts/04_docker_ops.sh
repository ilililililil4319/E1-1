#!/usr/bin/env bash
# Docker 기본 운영 명령 + hello-world + ubuntu + exec 관찰
source "$(dirname "$0")/lib.sh"
require_docker
docker rm -f hello ops-nginx obs-ubuntu > /dev/null 2>&1   # 이전 실습 잔여물 정리
start_log "04_docker_ops.md" "Docker 운영 / 컨테이너 실행 로그"

section "1. 이미지 다운로드 / 목록"
run "docker pull ubuntu:24.04"
run "docker pull nginx:1.27-alpine"
run "docker images"

section "2. hello-world 실행"
note "이미지가 없으면 자동 pull → 컨테이너 생성 → 메시지 출력 → 할 일이 끝나 종료(Exited)"
run "docker run --name hello hello-world"

section "3. 컨테이너 목록: 실행 중(ps) vs 전체(ps -a)"
run "docker ps"
note "hello-world 는 이미 종료되어 docker ps 에는 없고 docker ps -a 에만 보인다."
run "docker ps -a"

section "4. 실행 / 로그 / 리소스 / 중지"
run "docker run -d --name ops-nginx nginx:1.27-alpine"
run "docker ps"
run "docker logs ops-nginx"
run "docker stats --no-stream ops-nginx"
run "docker stop ops-nginx"
run "docker ps -a --filter name=ops-nginx"
run "docker start ops-nginx"
run "docker ps --filter name=ops-nginx"
run "docker rm -f ops-nginx"

section "5. ubuntu 컨테이너 안에서 명령 실행"
note "대화형(-it) 진입은 수동으로 수행 → README '수동 실습' 참고. 여기서는 같은 명령을 비대화형으로 기록."
run "docker run --rm ubuntu:24.04 bash -c 'ls / && echo hello-from-ubuntu'"

section "6. exec 관찰: exec 로 들어갔다 나와도 컨테이너는 계속 실행"
run "docker run -dit --name obs-ubuntu ubuntu:24.04 bash"
run "docker exec obs-ubuntu bash -c 'echo inside-by-exec && hostname'"
run "docker ps --filter name=obs-ubuntu"
note "exec 는 새 프로세스를 따로 열기 때문에, 그 프로세스가 끝나도 메인 프로세스(bash)는 살아 있다 → 상태 Up 유지."
note "attach 는 메인 프로세스에 직접 붙으므로 거기서 exit 하면 컨테이너가 종료된다 (수동 실습으로 확인)."
