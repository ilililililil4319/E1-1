#!/usr/bin/env bash
# Docker 설치 및 기본 점검
source "$(dirname "$0")/lib.sh"
start_log "03_docker_check.md" "Docker 설치 및 점검 로그"

section "1. 버전 확인 (설치되어 있는가?)"
run "docker --version"

section "2. 데몬(엔진) 동작 확인 (실제로 켜져서 응답하는가?)"
note "docker --version 은 설치만 확인. docker info 는 엔진이 살아 있어야 Server 정보가 나온다."
run "docker info"
