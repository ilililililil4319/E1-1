#!/usr/bin/env bash
# Dockerfile 커스텀 이미지 빌드 + 포트 매핑 2회 접속 확인
source "$(dirname "$0")/lib.sh"
require_docker
docker rm -f my-web-8080 my-web-8081 > /dev/null 2>&1
start_log "05_build_run.md" "커스텀 이미지 빌드 / 포트 매핑 로그"

section "1. Dockerfile 내용"
run "cat $REPO_ROOT/app/Dockerfile"

section "2. 이미지 빌드"
note "-t 이름:태그, 마지막 . = Dockerfile 이 있는 현재 폴더를 빌드 재료(컨텍스트)로 사용"
run "cd $REPO_ROOT/app"
run "docker build -t my-web:1.0 ."
run "docker images my-web"

section "3. 포트 매핑 실행 (같은 이미지로 2개, 호스트 포트만 다르게)"
note "-p 호스트포트:컨테이너포트  (밖:안)"
run "docker run -d -p 8080:80 --name my-web-8080 my-web:1.0"
run "docker run -d -p 8081:80 --name my-web-8081 my-web:1.0"
sleep 2
run "docker ps --filter name=my-web"

section "4. 접속 확인 (curl)"
run "curl -s http://localhost:8080"
run "curl -s http://localhost:8081"

section "5. 커스텀 포인트 확인"
run "docker exec my-web-8080 printenv APP_ENV"
run "docker inspect -f '{{json .Config.Labels}}' my-web:1.0"
note "헬스체크 결과 (healthy 가 될 때까지 최대 30초 대기)"
for i in $(seq 1 15); do
  [ "$(docker inspect -f '{{.State.Health.Status}}' my-web-8080 2>/dev/null)" = "healthy" ] && break
  sleep 2
done
run "docker inspect -f '{{.State.Health.Status}}' my-web-8080"
run "docker logs my-web-8080 | tail -5"

note "브라우저에서 http://localhost:8080 과 http://localhost:8081 을 열고, 주소창이 보이게 스크린샷 → docs/screenshots/"
