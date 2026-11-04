#!/usr/bin/env bash
# 권한 실습: 파일 1개 + 디렉토리 1개 권한 변경 전/후 비교
# 규칙: r=4, w=2, x=1 을 더해서 [소유자][그룹][그 외] 순서로 3자리
source "$(dirname "$0")/lib.sh"
start_log "02_permission.md" "권한 실습 로그"

run "mkdir -p ~/codyssey/practice && cd ~/codyssey/practice"
run "rm -rf perm_file.txt perm_dir"

section "1. 파일 권한: 644 → 755"
run 'echo "permission test" > perm_file.txt'
run "chmod 644 perm_file.txt"
note "변경 전: 644 = rw-r--r-- (소유자 읽기/쓰기, 나머지 읽기만)"
run "ls -l perm_file.txt"
run "chmod 755 perm_file.txt"
note "변경 후: 755 = rwxr-xr-x (소유자 전부, 나머지 읽기/실행)"
run "ls -l perm_file.txt"

section "2. 디렉토리 권한: 755 → 700"
run "mkdir perm_dir"
run "chmod 755 perm_dir"
note "변경 전: 755 = drwxr-xr-x (맨 앞 d = 디렉토리, -d 옵션 = 폴더 자체 권한 보기)"
run "ls -ld perm_dir"
run "chmod 700 perm_dir"
note "변경 후: 700 = drwx------ (소유자만 모든 권한, 다른 사람은 아무것도 못 함)"
run "ls -ld perm_dir"

section "3. 실험: 디렉토리의 x(실행) 권한을 빼면?"
note "디렉토리의 x = 안으로 들어갈(cd) 수 있는 권한"
run "chmod 600 perm_dir"
run "ls -ld perm_dir"
try "cd perm_dir"
cd ~/codyssey/practice   # (관리자 계정이라 들어가졌더라도 원위치)
note "→ Permission denied: x 가 없어서 들어갈 수 없다. (root/관리자 계정은 권한을 무시하므로 들어가질 수 있음)"
run "chmod 755 perm_dir"
run "cd perm_dir && pwd && cd .."

section "4. 문자 방식 chmod"
run "chmod u-x,g-x,o-x perm_file.txt"
run "ls -l perm_file.txt"
note "u=소유자, g=그룹, o=그 외 / + 추가, - 제거"
