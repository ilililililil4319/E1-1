#!/usr/bin/env bash
# 터미널 기본 조작: 위치 확인 / 목록(숨김 포함) / 이동 / 생성 / 복사 / 이름변경 / 삭제 / 내용 확인 / 빈 파일
# 실습 폴더: ~/codyssey/practice  (개인 PC 경로이므로 각자 홈 폴더 기준으로 바뀜)
source "$(dirname "$0")/lib.sh"
rm -rf "$HOME/codyssey/practice"     # 다시 실행해도 같은 결과가 나오도록 초기화
start_log "01_terminal.md" "터미널 조작 로그"

section "1. 현재 위치 확인"
run "cd ~"
run "pwd"

section "2. 폴더 생성 (중간 폴더까지 한 번에: -p)"
run "mkdir -p ~/codyssey/practice"

section "3. 이동 - 절대 경로"
note "절대 경로: 루트(/)부터 시작하는 전체 주소라 어디서 실행해도 같은 곳으로 간다."
run "cd $HOME/codyssey/practice"
run "pwd"

section "4. 이동 - 상대 경로"
note "상대 경로: 현재 위치 기준. .. = 한 칸 위, . = 현재 폴더"
run "cd .."
run "pwd"
run "cd ./practice"
run "pwd"

section "5. 빈 파일 생성 / 목록 확인 (숨김 파일 포함)"
run "touch empty.txt"
run "touch .hidden_file"
run "ls -la"

section "6. 파일에 내용 쓰기 / 내용 확인"
run 'echo "hello codyssey" > hello.txt'
run 'echo "second line" >> hello.txt'
run "cat hello.txt"

section "7. 하위 폴더 생성 후 복사"
run "mkdir backup"
run "cp hello.txt backup/hello_copy.txt"
run "ls -la backup"

section "8. 이동 / 이름 변경"
run "mv backup/hello_copy.txt backup/hello_renamed.txt"
run "mv empty.txt backup/"
run "ls -la backup"

section "9. 삭제"
run "rm backup/hello_renamed.txt"
run "rm backup/empty.txt"
run "rmdir backup"
run "ls -la"
