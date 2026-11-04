#!/usr/bin/env bash
# 보너스: Docker Compose up / ps / logs / down + 컨테이너 간 통신 + 환경 변수
source "$(dirname "$0")/lib.sh"
require_docker
start_log "09_compose.md" "보너스: Docker Compose 로그"

run "cd $REPO_ROOT/compose"
run "cat docker-compose.yml"

section "1. 실행 (up)"
run "APP_ENV=dev WEB_PORT=8090 docker compose up -d --build"
sleep 5

section "2. 상태 (ps)"
run "docker compose ps"

section "3. 컨테이너 간 통신 확인 (checker → web)"
run "docker compose logs checker"
run "docker compose exec web printenv APP_ENV"
run "curl -s http://localhost:8090"

section "4. 로그 (logs)"
run "docker compose logs web | tail -5"

section "5. 종료 (down)"
run "docker compose down"
run "docker compose ps"
