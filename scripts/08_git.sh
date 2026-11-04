#!/usr/bin/env bash
# Git 사용자 정보 / 기본 브랜치 설정 + 확인
# 사용법: ./scripts/08_git.sh "내 이름" "내 GitHub 이메일"
#        (이미 설정했다면 인자 없이 실행 → 확인만)
source "$(dirname "$0")/lib.sh"
start_log "08_git.md" "Git 설정 / GitHub 연동 로그"

section "1. 설정"
run "git --version"
if [ -n "$1" ] && [ -n "$2" ]; then
  run "git config --global user.name \"$1\""
  run "git config --global user.email \"$2\""
fi
run "git config --global init.defaultBranch main"

section "2. 설정 확인"
run "git config --list"

section "3. 저장소 연동 확인"
run "cd $REPO_ROOT"
run "git remote -v"
run "git branch"
run "git log --oneline -5"

note "VSCode GitHub 로그인 화면 스크린샷을 docs/screenshots/ 에 저장 (이메일·토큰은 가리기)"
