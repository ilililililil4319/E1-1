#!/usr/bin/env bash
# 포트 충돌 진단 및 해제
#  1) 컨테이너끼리 같은 호스트 포트를 쓰려 할 때 → 누가 쓰는지 찾고 → 해제 → 재실행
#  2) 일반 프로세스가 포트를 점유할 때 → ss / lsof 로 PID 확인 → kill 로 해제
source "$(dirname "$0")/lib.sh"
require_docker
docker rm -f port-a port-b > /dev/null 2>&1
start_log "10_port_check.md" "포트 충돌 진단 및 해제 로그"

section "1. 포트 충돌 재현 (같은 호스트 포트 8085 를 두 번 사용)"
run "docker run -d -p 8085:80 --name port-a nginx:1.27-alpine"
note "같은 호스트 포트로 두 번째 컨테이너를 실행 → 실패가 예상됨"
try "docker run -d -p 8085:80 --name port-b nginx:1.27-alpine"
note "→ 'port is already allocated': 호스트 포트 8085 를 이미 누가 쓰고 있다는 뜻"

section "2. 진단: 포트 8085 를 쓰는 컨테이너 찾기"
run "docker ps --filter publish=8085 --format 'table {{.Names}}\t{{.Ports}}\t{{.Status}}'"
run "docker port port-a"
note "실패한 port-b 는 생성만 되고 시작되지 않은 상태(Created)로 남는다"
run "docker ps -a --filter name=port-b --format 'table {{.Names}}\t{{.Status}}'"

section "3. 해제 후 재실행"
run "docker stop port-a"
run "docker rm port-a port-b"
run "docker run -d -p 8085:80 --name port-b nginx:1.27-alpine"
sleep 2
note "응답 상태 코드로 정상 동작 확인 (200 = 성공)"
run "curl -s -o /dev/null -w 'HTTP %{http_code}\n' http://localhost:8085"
run "docker rm -f port-b"

section "4. 일반 프로세스가 포트를 점유한 경우 (PID 확인 → kill)"
note "파이썬 간이 웹 서버로 8099 포트를 일부러 점유"
python3 -m http.server 8099 > /dev/null 2>&1 &
PY_PID=$!
sleep 1
note "백그라운드로 실행한 프로세스 PID: $PY_PID"
if command -v ss > /dev/null 2>&1; then
  try "ss -ltnp | grep ':8099'"            # -l 대기중 -t TCP -n 숫자 -p 프로세스
else
  try "lsof -i :8099"
fi
try "timeout 3 python3 -m http.server 8099 2>&1 | tail -1"
note "→ 'Address already in use': 같은 포트를 다른 프로그램이 쓰고 있음"
run "kill $PY_PID"
sleep 1
note "해제 확인: '사용하는 프로세스 없음' 이 나오면 포트가 비어 있음"
if command -v ss > /dev/null 2>&1; then
  try "ss -ltnp | grep ':8099' || echo '8099 포트를 사용하는 프로세스 없음'"
else
  try "lsof -i :8099 || echo '8099 포트를 사용하는 프로세스 없음'"
fi
