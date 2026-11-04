#!/usr/bin/env bash
# 실행 환경 기록: OS / 쉘 / 터미널 / Docker 버전 / Git 버전
source "$(dirname "$0")/lib.sh"
start_log "00_env.md" "실행 환경"

section "OS"
if [ "$(uname)" = "Darwin" ]; then
  run "sw_vers"            # macOS 버전
else
  run "cat /etc/os-release | head -4"
fi
run "uname -m"              # CPU 종류 (arm64 = 애플 실리콘, x86_64 = 인텔/AMD)

section "쉘 / 터미널"
run 'echo "SHELL=$SHELL"'
run '"$SHELL" --version 2>&1 | head -1'
run 'echo "TERM_PROGRAM=${TERM_PROGRAM:-unknown}"'

section "Docker / Git 버전"
run "docker --version"
run "git --version"
